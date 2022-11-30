<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="team.Team" %>
<%@ page import="team.TeamDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale"="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>충북대 소프트웨어학과 과목별 게시판</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		
		int bbsID = 0;
		if(request.getParameter("bbsID")!=null){ //매개변수로 넘어온 bbsID가 존재한다면
			bbsID = Integer.parseInt(request.getParameter("bbsID")); //현재 파일 변수 bbsID에 bbsID 넣어주기
		}
		if(bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'"); 
			script.println("</script>");
		}
		//코드 4줄의 import bbs.Bbs 덕에 쓸 수 있는 
		Bbs bbs = new BbsDAO().getBbs(bbsID); //유효한 글이라면 Bbs라는 인스턴스 안에 내용 담기
	%>
  <nav class="navbar navbar-default">
  	<div class="navbar-header">
  		<button type="button" class="navbar-toggle collapsed"
  			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
  			aria-expanded="false">
  			<span class="icon-bar"></span>
  			<span class="icon-bar"></span>
  			<span class="icon-bar"></span>
  		</button>
  		<a class="navbar-brand" href="main.jsp">충북대 소프트웨어학과 과목별 게시판</a>
  	</div>
  	<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  		<ul class="nav navbar-nav">
  			<li><a href="main.jsp">메인</a></li>
  			<li class="active"><a href="bbs.jsp">게시판</a></li>
  		</ul>
  		<%
  			if(userID == null){ //로그인이 되어있지 않다면
  		%>
  		<ul class="nav navbar-nav navbar-right">
  			<li class="dropdown">
  				<a href="#" class="dropdown-toggle"
  					data-toggle="dropdown" role="button" aria-haspopup="true"
  					aria-expanded="false">접속하기<span class="caret"></span></a>
  				<ul class="dropdown-menu">
  					<li><a href="login.jsp">로그인</a></li>
  					<li><a href="join.jsp">회원가입</a></li>
  				</ul>
  			</li>
  		</ul>
  		<%
  			} else{ //로그인이 되어있다면
		%>
		<ul class="nav navbar-nav navbar-right">
  			<li class="dropdown">
  				<a href="#" class="dropdown-toggle"
  					data-toggle="dropdown" role="button" aria-haspopup="true"
  					aria-expanded="false">회원관리<span class="caret"></span></a>
  				<ul class="dropdown-menu">
  					<li><a href="logoutAction.jsp">로그아웃</a></li>
  				</ul>
  			</li>
  		</ul>
  		<%		
  			}
  		%>
  	</div>
  </nav>
  <div class="container">
  	<div class="row">
  		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
  			<thead>
  				<tr>
  					<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 보기 양식</th>
  				</tr>
  			</thead>
  			<tbody>
  				<tr>
  					<td style="width: 20%;">글 제목</td>
  					<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
  				</tr>
  				<tr>
  					<td>작성자</td>
  					<td colspan="2"><%= bbs.getUserID() %></td>
  				</tr>
  				<tr>
  					<td>작성일자</td>
  					<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시 " + bbs.getBbsDate().substring(14, 16) + "분" %></td>
  				</tr>
  				<tr>
  					<td>내용</td>
  					<td colspan="2" style="height: 300px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
  				</tr>
  				<%
  					//'팀 구해요'게시글 이라면,
  					String str1 = "팀 구해요";
  					if(str1.equals(bbs.getTopic())){
  				%>
  				<%
	            	TeamDAO teamDAO= new TeamDAO();
	            	ArrayList<Team> list = teamDAO.getList();
                %>
  				<tr>
  					<td>팀 매칭 현황</td>
  					<td colspan="2"><%= bbs.getCurrentpeople() + " / " + bbs.getTotalpeople()%></td>
  				</tr>
  				<tr>
  					<td>팀 신청하기</td>
  					<td colspan="2"><a href="teamAction.jsp?userID=<%= userID %>&bbsID=<%= bbsID %>" class="btn btn-primary">팀 신청하기</a></td>
  				</tr>
  				<tr>
  					<td>팀 신청자 목록</td>
  					<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  					<%
			  		 	if(userID != null && userID.equals(bbs.getUserID())){ //글 사용자가 해당 글의 작성자와 동일하다면
			  		%>
  					<td colspan="2">
  					영입할 멤버 고르세요 : 
  					<form method="post" action="viewAction.jsp?bbsID=<%= bbsID%>">
	                    <select id="member" name="member">
		                    <option>멤버</option>
	                    </select>
	                    <input type="submit" class="btn btn-primary pull-right" value="영입">
                    </form>
				    <script>
		            	var mem = [];
                    <%
		            	for(int i=0; i<list.size(); i++) {
		            		if(list.get(i).getBbsID()==bbs.getBbsID()&&list.get(i).getTeamcheck()==0){
		            %>
			            mem.push("<%= list.get(i).getUserID() %>");
		            <% 
		            		} 
		            	}
		            %>
			            for ( var i = 0; i < mem.length; i++ ) {
			            	$( '#member' ).append( '<option value='+mem[i]+'>' + mem[i]+ '</option>' );
			            }
		            </script>
		            <%
				  		 	}
		            %>
		            
		            </br></br>
		            <%
						for(int i=0; i<list.size(); i++) {
							if(list.get(i).getBbsID()==bbs.getBbsID()&&list.get(i).getTeamcheck()==0){
		            %>
		            <%= "신청자 : "+list.get(i).getUserID()+" " %>
		            
		            <%
							}
						} 
		            %>
  					</td>
  				</tr>
  				<%
  					//글 작성자만 볼 수 있게 하는 if문 끝 괄호
  					}
  				%>
  			</tbody>
  		</table>
  		<a href="bbs.jsp" class="btn btn-primary">목록</a>
  		<%
  		 	if(userID != null && userID.equals(bbs.getUserID())){ //글 사용자가 해당 글의 작성자와 동일하다면
  			
  		 		//update.jsp에 해의 ID를 가져갈 수 있게 함 (아래 코드 설명)
  		%>
  				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
  				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
  		<% 
  		 }
  		%>
  		<div style="height:30px;"></div>
  		<div class="container">
				<div class="row">
					<table class="table table-striped"
						style="text-align: center; border: 1px solid #dddddd">
						<tbody>
							<tr>
								<td align="left" style="color: black; background-color: #B0E0E6; font-family: 'Jua', sans-serif; font-size:20px;" >댓글</td>
								
							</tr>
							<tr>
								<%
									ReplyDAO replyDAO = new ReplyDAO();
									ArrayList<Reply> list2 = replyDAO.getList(bbsID);
									for (int i = 0; i < list2.size(); i++) {
								%>
								<div class="container">
									<div class="row">
										<table class="table table-striped"
											style="text-align: center; border: 1px solid #dddddd">
											<tbody>
												<tr>
													<td align="left" style="width:100%;"><%=list2.get(i).getUserID()%></td>	
												</tr>
												<tr>
													<td align="left"><%=list2.get(i).getReplyContent()%></td>
													<!-- 댓글 삭제 버튼 -->
													<td align="right"><a
														onclick="return confirm('정말로 삭제하시겠습니까?')"
														href="replyDeleteAction.jsp?bbsID=<%=bbsID%>&replyID=<%=list2.get(i).getReplyID()%>"
														class="btn btn-danger" style="color: black; background-color: #FF6347 ; font-family: 'Jua', sans-serif; font-size:15px;"">삭제</a></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<%
									}
								%>
							</tr>
					</table>
				</div>
			</div>
			<br>
			<div class="container">
				<div class="row">
					<form method="post" action="submitAction.jsp?bbsID=<%=bbsID%>">
						<table class="table table-bordered"
							style="text-align: center; border: 1px solid #dddddd">
							<tbody>
								<tr>
									<td align="left"><%=userID%></td>
								</tr>
								<tr>
									<td><input type="text" class="form-control" 
										placeholder="댓글쓰기" name="replyContent" maxlength="500"></td>
								</tr>
							</tbody>
						</table>
						<input type="submit" class="btn btn-success pull-right" style="color:black; background-color:#98FB98 ; font-family: 'Jua', sans-serif; font-size:15px;"
							value="댓글쓰기">
					</form>
				</div>
			</div>
		</div>
	</div>
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  <script src="js/bootstrap.js"></script>
</body>
</html>