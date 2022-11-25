// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

/**
 * @title IBlogService
 * @author anonymous
 */
interface IBlogService {
    error ErrNotPermitted();
    event BlogCreated(uint256);
    event BlogUpdated(uint256);
    struct Blog {
        uint256 id;
        string title;
        string content;
        address author;
        uint256 create_timestamp;
    }

    /**
     * @notice addBlog is used to create a new blog.
     * @param title_ blog title.
     * @param content_ blog content.
     */
    function addBlog(string calldata title_, string calldata content_) external;

    /**
     * @notice getBlog is used to get a blog by id.
     * @param blogId_ blog id.
     * @return Blog blog data.
     */
    function getBlog(uint256 blogId_) external view returns (Blog memory);

    /**
     * @notice getBlogCount is used to get the total number of published blogs.
     * @return the total number of published blogs.
     */
    function getBlogCount() external view returns (uint256);

    /**
     * @notice updateBlog is used to update the content of the blog, and only the creator of the blog has permission.
     * @param blogId_ the id of blog.
     * @param title_ the title of the corresponding blog will be set to this.
     * @param content_ the content of the corresponding blog will be set to this.
     */
    function updateBlog(
        uint256 blogId_,
        string memory title_,
        string memory content_
    ) external;

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
        returns (Blog[] memory data, uint256 nextCursor);
}
