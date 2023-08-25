<%@ page language="java" import="java.util.*" %> 
<%@ page import="java.util.Properties, java.io.InputStream, java.io.IOException, java.io.FileInputStream" %>
<%@ page import="java.sql.Connection,java.sql.DriverManager, java.sql.SQLException, java.sql.*" %>

<!-- 
	@doguedogue
 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Conexión SQL Server</title>
</head>
<body>
	<b><label>Conexión SQL Server</label></b><br><br>	
	<b><label>Variables Weblogic</label></b><br>
	<% String prefix = "";%>
	<% String prop = prefix+"PROPERTIES"; %>
	<% String files = prefix+"FILES"; %>
	<% String logs = prefix+"LOGS"; %>
	<label>Properties</label><% String wp = System.getenv (prop); out.println(" ("+prop+"): "+wp); %><br>
	<label>Files</label><% String wf = System.getenv (files); out.println(" ("+files+"): "+wf); %><br>
	<label>Logs</label><% String wl = System.getenv (logs); out.println(" ("+logs+"): "+wl); %><br>
	<br>
	<b><label>Lectura de Propiedades</label></b><br>
	<%
		Properties properties= new Properties();
		String jdbcUrl = ""; 
		String username = "";
		String password = "";
		String connectionUrl = "";
		String file_prop = "sqlserver.properties";
		try (InputStream input = new FileInputStream(wp+"/"+file_prop)) {
			properties.load(input);

			jdbcUrl = (String)properties.get("spring.datasource-sqlserver.url");
			username = (String)properties.get("spring.datasource-sqlserver.username");
			password = (String)properties.get("spring.datasource-sqlserver.password");
			
			// Create a variable for the connection string.
	    	connectionUrl = jdbcUrl + ";username=" + username + ";password=" + password + ";";
	            
			out.println("<ul>");
			out.println("<li>JdbcUrl: "+jdbcUrl+"</li>");
			out.println("<li>Username: "+username+"</li>");
			//out.println("<li>"+password+"</li>");
			out.println("<li>Connection Url: "+connectionUrl.replace(password, "XXXXXXXX")+"</li>");			
			out.println("</ul>");
			
	    } catch (IOException ex) {
	        ex.printStackTrace();
	    }		
		
		try {     
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (ClassNotFoundException e) {     
			out.println("An error occurred to get the Driver<br>");
	    	out.println("&nbsp;&nbsp;&nbsp;&nbsp;"+e.toString().replace(password, "XXXXXXXX")+"<br>");
	        e.printStackTrace();
		}
		%>
		
		
		
	<b><label>Conexión de base de datos</label></b><br>
	<%	
			
		out.println("<ul>");


		 try {
			 Connection conn1 = DriverManager.getConnection(connectionUrl); 			 
			 out.println("<li>Connected to the database test"+"</li>");
			 
			 if (conn1 != null) {
		        	
		        	//Query
		        	String tabla = "tabla";
		        	String col1 = "col1";
		        	String col2 = "col2";
		        	String col3 = "col3";
		        	String col4 = "col4";
		        	%>
		        	<h3>Consulta vista: <%out.println(tabla);%></h3>
		        	<table border="1">
		        	<tr>
			        	<td><%out.println(col1.toUpperCase());%></td>
			        	<td><%out.println(col2.toUpperCase());%></td>
			        	<td><%out.println(col3.toUpperCase());%></td>
			        	<td><%out.println(col4.toUpperCase());%></td>
		        	</tr>	        	
		        	<%
		        	try{	        	
		        	Statement statement=conn1.createStatement();
		        	//where rownum <= 5 order by 1 desc
		        	String sql ="select * from "+tabla;
		        	ResultSet resultSet  = statement.executeQuery(sql);
		        	while(resultSet.next()){
		        	%>
		        	<tr>
			        	<td><%=resultSet.getString(col1) %></td>
			        	<td><%=resultSet.getString(col2) %></td>
			        	<td><%=resultSet.getString(col2) %></td>
			        	<td><%=resultSet.getString(col4) %></td>
		        	</tr>
		        	<%
		        	}
		        	conn1.close();
		        	} catch (Exception e) {
		        		e.printStackTrace();
		        	}
		        	%>	        	
		        	</table><br>
		        	<%
		        }
	       
	     }catch (SQLException ex) {
		    	out.println("<li>An error occurred.<b>test</b>"+"</li>");
		    	out.println("&nbsp;&nbsp;&nbsp;&nbsp;"+ex.toString().replace(password, "XXXXXXXX")+"<br>");
		        ex.printStackTrace();
		   }	
		    
		    
			out.println("</ul><br>");
	
		
	%>
	
</body>
</html>