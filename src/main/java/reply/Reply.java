package reply;

public class Reply {
	private String replyContent; 
	private int replyID;
	private String userID;
	private int replyAvailable;
	private int bbsID;
	
	public String getReplyContent() {
		return replyContent;
	}
	public void setReplyContent(String replyContent) {
		this.replyContent = replyContent;
	}
	public int getReplyID() {
		return replyID;
	}
	public void setReplyID(int replyID) {
		this.replyID = replyID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public int getReplyAvailable() {
		return replyAvailable;
	}
	public void setReplyAvailable(int replyAvailable) {
		this.replyAvailable = replyAvailable;
	}
	public int getBbsID() {
		return bbsID;
	}
	public void setBbsID(int bbsID) {
		this.bbsID = bbsID;
	}
}