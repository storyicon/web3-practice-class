// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

/**
 * @title ICommentService
 * @author anonymous
 */
interface ICommentService {
    struct Comment {
        string content;
        address author;
        uint256 create_timestamp;
    }

    /**
     * @notice addComment is used to add a comment to the blog with the given blogId.
     * @param blogId_ the id of blog.
     * @param content_ the content of comment.
     */
    function addComment(uint256 blogId_, string calldata content_) external;

    /**
     * @notice getCommentCount is used to get the total number of comments on a blog with the given blogId.
     * @param blogId_ the id of blog.
     * @return the total number of comments of this blog.
     */
    function getCommentCount(uint256 blogId_) external view returns (uint256);

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
    ) external view returns (Comment[] memory data, uint256 nextCursor);
}
