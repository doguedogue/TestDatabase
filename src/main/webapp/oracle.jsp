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
<title>Conexión Oracle</title>
</head>
<body>
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
		String driver = "";
		String file_prop = "file.properties";
		try (InputStream input = new FileInputStream(wp+"/"+file_prop)) {
			properties.load(input);

			jdbcUrl = (String)properties.get("spring.datasource-oracle.url");
			username = (String)properties.get("spring.datasource-oracle.username");
			password = (String)properties.get("spring.datasource-oracle.password");
			driver = (String)properties.get("spring.datasource-oracle.driverClassName");			

			out.println("<ul>");
			out.println("<li>JdbcUrl: "+jdbcUrl+"</li>");
			out.println("<li>Username: "+username+"</li>");
			//out.println("<li>"+password+"</li>");
			out.println("<li>Driver: "+driver+"</li>");
			out.println("</ul>");
			
	    } catch (IOException ex) {
	        ex.printStackTrace();
	    }		
		%>
		
	<b><label>Conexión de base de datos</label></b><br>
	<%	
		try {
			Class.forName(driver);
		} catch (Exception ex) {
			out.println("Error al leer el driver: "+driver+"<br>");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;"+ex.toString()+"<br>");
	        ex.printStackTrace();
	    }	
	
		//creates three different Connection objects
	    Connection conn1 = null;
	    Connection conn2 = null;
	    Connection conn3 = null;
	    //only if some Locale errors appear
	    Locale.setDefault(Locale.ENGLISH);
		out.println("<ul>");	
	    try {
	        // connect way #1
	        conn1 = DriverManager.getConnection(jdbcUrl, username, password);
	        if (conn1 != null) {
	        	out.println("<li>Connected to the database test1"+"</li>");
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
	
	    } catch (SQLException ex) {
	    	out.println("<li>An error occurred.<b>test1</b> Maybe user/password is invalid"+"</li>");
	    	out.println("&nbsp;&nbsp;&nbsp;&nbsp;"+ex.toString()+"<br>");
	        ex.printStackTrace();
	    }	
	    
	    try {
	        // connect way #2
	        String url2 = jdbcUrl+"user="+username+"&password="+password;
	        conn2 = DriverManager.getConnection(url2);
	        if (conn2 != null) {
	        	out.println("<li>Connected to the database test2"+"</li>");
	        }
	    } catch (SQLException ex) {
	    	out.println("<li>An error occurred.<b>test2</b> Maybe user/password is invalid"+"</li>");
	    	out.println("&nbsp;&nbsp;&nbsp;&nbsp;"+ex.toString()+"<br>");
	        ex.printStackTrace();
	    }	
	    
	    try {
	        // connect way #3
	        Properties info = new Properties();
	        info.put("user", username);
	        info.put("password", password);
	
	        conn3 = DriverManager.getConnection(jdbcUrl, info);
	        if (conn3 != null) {
	        	out.println("<li>Connected to the database test3"+"</li>");
	        }
	    } catch (SQLException ex) {
	    	out.println("<li>An error occurred.<b>test3</b> Maybe user/password is invalid"+"</li>");
	    	out.println("&nbsp;&nbsp;&nbsp;&nbsp;"+ex.toString()+"<br>");
	        ex.printStackTrace();
	    }	
		out.println("</ul><br>");
		
	%>
	
</body>
</html>