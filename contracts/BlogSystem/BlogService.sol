// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {IBlogService} from "./IBlogService.sol";

/**
 * @title BlogService
 * @author anonymous
 */
contract BlogService is IBlogService {
    mapping(uint256 => Blog) internal _blogs;
    uint256 internal _nextBlogId;

    /**
     * @notice addBlog is used to create a new blog.
     * @param title_ blog title.
     * @param content_ blog content.
     */
    function addBlog(string calldata title_, string calldata content_)
        external
    {
        Blog memory blog = Blog({
            id: _nextBlogId,
            title: title_,
            content: content_,
            author: msg.sender,
            create_timestamp: block.timestamp
        });
        _blogs[_nextBlogId] = blog;
        emit BlogCreated(_nextBlogId);
        _nextBlogId++;
    }

    /**
     * @notice getBlog is used to get a blog by id.
     * @param blogId_ blog id.
     * @return Blog blog data.
     */
    function getBlog(uint256 blogId_) external view returns (Blog memory) {
        return _blogs[blogId_];
    }

    /**
     * @notice getBlogCount is used to get the total number of published blogs.
     * @return the total number of published blogs.
     */
    function getBlogCount() external view returns (uint256) {
        return _nextBlogId;
    }

    /**
     * @notice updateBlog is used to update the content of the blog, and only the creator of the blog has permission.
     * @param blogId_ the id of blog.
     * @param title_ the title of the corresponding blog will be set to this.
     * @param content_ the content of the corresponding blog will be set to this.
     */
    function updateBlog(
        uint256 blogId_,
        string calldata title_,
        string calldata content_
    ) external {
        Blog storage blog = _blogs[blogId_];
        if (blog.author != msg.sender) revert ErrNotPermitted();
        blog.title = title_;
        blog.content = content_;
        emit BlogUpdated(blogId_);
    }

    /**
     * @notice listBlog is used to list the blogs that have been published, and it adopts the way of cursor pagination.
     * @param cursor_ cursor, the initial cursor is 0.
     * @param size_ define the amount per page.
     * @return data the array of blogs.
     * @return nextCursor next page cursor.
     */
    function listBlog(uint256 cursor_, uint256 size_)
        external
        view
        returns (Blog[] memory data, uint256 nextCursor)
    {
        size_ = cursor_ + size_ > _nextBlogId ? _nextBlogId - cursor_ : size_;
        data = new Blog[](size_);
        for (uint256 i = 0; i < size_; i++) {
            data[i] = _blogs[cursor_ + i];
        }
        return (data, cursor_ + size_);
    }
}
