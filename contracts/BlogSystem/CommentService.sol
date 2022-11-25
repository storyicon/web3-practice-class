// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import {IBlogService} from "./IBlogService.sol";
import {ICommentService} from "./ICommentService.sol";

/**
 * @title CommentService
 * @author anonymous
 */
contract CommentService is ICommentService {
    error ErrBlogNotExists();
    event CommentCreated(uint256 blogId);

    mapping(uint256 => Comment[]) internal _blogComments;
    address internal _blogContractAddress;

    constructor(address blogContractAddress_) {
        _blogContractAddress = blogContractAddress_;
    }

    /**
     * @notice addComment is used to add a comment to the blog with the given blogId.
     * @param blogId_ the id of blog.
     * @param content_ the content of comment.
     */
    function addComment(uint256 blogId_, string calldata content_)
        external
        onlyBlogExists(blogId_)
    {
        _blogComments[blogId_].push(
            Comment({
                content: content_,
                author: msg.sender,
                create_timestamp: block.timestamp
            })
        );
        emit CommentCreated(blogId_);
    }

    /**
     * @notice getCommentCount is used to get the total number of comments on a blog with the given blogId.
     * @param blogId_ the id of blog.
     * @return the total number of comments of this blog.
     */
    function getCommentCount(uint256 blogId_)
        external
        view
        onlyBlogExists(blogId_)
        returns (uint256)
    {
        return _blogComments[blogId_].length;
    }

    /**
     * @notice listComment is used to list the comments of specified blog, and it adopts the way of cursor pagination.
     * @param blogId_ the id of blog.
     * @param cursor_ cursor, the initial cursor is 0.
     * @param size_ define the amount per page.
     * @return data the array of comments.
     * @return nextCursor next page cursor.
     */
    function listComment(
        uint256 blogId_,
        uint256 cursor_,
        uint256 size_
    ) external view returns (Comment[] memory data, uint256 nextCursor) {
        Comment[] storage comments = _blogComments[blogId_];
        size_ = cursor_ + size_ > comments.length
            ? comments.length - cursor_
            : size_;
        data = new Comment[](size_);
        for (uint256 i = 0; i < size_; i++) {
            data[i] = comments[cursor_ + i];
        }
        return (data, cursor_ + size_);
    }

    /**
     * @notice onlyBlogExists is used to restrict the subsequent logic of the modified
     * function to be executed only if the Blog with the given ID exists.
     * @param blogId_ the id of blog.
     */
    modifier onlyBlogExists(uint256 blogId_) {
        IBlogService.Blog memory blog = IBlogService(_blogContractAddress)
            .getBlog(blogId_);
        if (blog.id == 0) revert ErrBlogNotExists();
        _;
    }
}
