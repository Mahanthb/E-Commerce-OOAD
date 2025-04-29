<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.springspartans.shopkart.model.Order" %> 
<%@ page import="com.springspartans.shopkart.model.Order.OrderStatus"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ShopKart | Manage Orders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/colorScheme.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/colorSchemeForOrderStatus.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/manageOrders.css" />
  </head>
  <body>
  <%@ include file="../../templates/admin_sidebar.jsp" %>
    <div style="margin-left: 300px; margin-right: 50px">
    	<%@ include file="../../templates/admin_header.jsp" %>
      <h2 style="font-size: 40px; margin-bottom: 20px">Manage Orders</h2>
      <div class="container-filter-shippingCategory">
        <div class="dropdown-container">
            <label style="color : var(--base-text);"for="shippingCategory">Select Order Status:</label>
            <select name="shippingCategory" id="shippingCategory" onchange="window.location.href='/admin/dashboard/order/status/' + this.value">
                <option value=""></option>
                <option value="All">All</option>
                <option value="Pending">Pending</option>
                <option value="Shipped">Shipped</option>
                <option value="Delivered">Delivered</option>
                <option value="Cancelled">Cancelled</option>
            </select>
        </div>
        
        <% int[] orderCountByStatusArr = (int [])request.getAttribute("orderCountByStatusArr"); %>
        <% String orderStatus = (String)request.getAttribute("status"); %>
        
        <% if (orderStatus == null || orderStatus.equals("All")) { %>
        	<div class="categry pending">
	            <h2 id="pending-text">Pending</h2>
	            <h1><%= orderCountByStatusArr[0] %></h1>
	        </div>
	        <div class="categry shipped">
	            <h2>Shipped</h2>
	            <h1><%= orderCountByStatusArr[1] %></h1>
	        </div>
	        <div class="categry delivered">
	            <h2>Delivered</h2>
	            <h1><%= orderCountByStatusArr[2] %></h1>
	        </div>
	        <div class="categry cancelled">
	            <h2>Cancelled</h2>
	            <h1><%= orderCountByStatusArr[3] %></h1>
	        </div>
        <% } else if (orderStatus.equals("Pending")) { %>
        	<div class="categry pending">
	            <h2 id="pending-text">Pending</h2>
	            <h1><%= orderCountByStatusArr[0] %></h1>
	        </div>
        <% } else if (orderStatus.equals("Shipped")) { %>
        	<div class="categry shipped">
	            <h2>Shipped</h2>
	            <h1><%= orderCountByStatusArr[1] %></h1>
	        </div>
        <% } else if (orderStatus.equals("Delivered")) { %>
        	<div class="categry delivered">
	            <h2>Delivered</h2>
	            <h1><%= orderCountByStatusArr[2] %></h1>
	        </div>
        <% } else if (orderStatus.equals("Cancelled")) { %>
        	<div class="categry cancelled">
	            <h2>Cancelled</h2>
	            <h1><%= orderCountByStatusArr[3] %></h1>
	        </div>
        <% } %>
        
    </div>
      <div class="search-bar" style="margin : 20px;">
      	<form action="/admin/dashboard/order/search" method="get">
      		<input
	          name="custId"
	          type="number"
	          style="color: black"
	          placeholder="search by customer-id..."
	          required
	        />
	        <button type="submit">Search</button>
      	</form>
      </div>
      
      <% List<Order> orderList = (List<Order>)request.getAttribute("orderList"); %>
      <table>
        <thead>
          <tr>
            <th>Order-ID</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Quantity</th>
            <th>Order Date</th>
            <th>Delivered Date</th>
            <th>Status</th>
            <th>Total-amount</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <% if (orderList != null) { %>
        	<% for (Order order : orderList) { %>
	          <tr>
	            <td>
	              <h4>ORD<%= String.format("%04d", order.getId()) %></h4>
	            </td>
	            <td>
	            	<div class="name">
	            		<% String profilePic = order.getCustomer().getProfilePic(); %>
	            		<% if (profilePic != null) { %>
	            			<img src="${pageContext.request.contextPath}/uploads/customer/<%= profilePic %>" alt="<%= profilePic %>">
	            		<% } else { %>
	            			<img src="${pageContext.request.contextPath}/images/avatar.jpg" alt="avatar">
	            		<% } %>
	            		<h4><%= order.getCustomer().getName() %> (CUST<%= String.format("%04d", order.getCustomer().getId()) %>)</h4>
	            	</div>
	            </td>
	            <td>
	            	<div class="name">
	            		<img src="${pageContext.request.contextPath}/uploads/product/<%= order.getProduct().getImage() %>" alt="<%= order.getProduct().getImage() %>">
	            		<h4><%= order.getProduct().getName() %></h4>
	            	</div>
	            </td>
	            <td><h4><%= order.getQuantity() %></h4></td>
	            <td>
		        	<%
						Timestamp orderDate = order.getOrder_date();
						String formattedOrderDate = "";
						if (orderDate != null) {
							Date date = new Date(orderDate.getTime());
							SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy");
							formattedOrderDate = formatter.format(date);
						} else {
							formattedOrderDate = "NA";
						}
					%>
		            <h4><%= formattedOrderDate %></h4>
		        </td>
		        <td>
		            <%
						Timestamp deliveredDate = order.getDelivered_date();
						String formattedDeliveredDate = "";
						if (deliveredDate != null) {
							Date date = new Date(deliveredDate.getTime());
							SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy");
							formattedDeliveredDate = formatter.format(date);
						} else {
							formattedDeliveredDate = "Not delivered";
						}
					%>
		            <h4><%= formattedDeliveredDate %></h4>
		        </td>
	            <td>
	                <% OrderStatus status = order.getStatus(); %> 
		            <% if (status.equals(OrderStatus.Pending)) { %>  
		                <div class="status-pending">
				        	<h3>Pending</h3>
				        </div> 
		            <% } else if (status.equals(OrderStatus.Shipped)) { %> 
		                <div class="status-shipped">
				            <h3>Shipped</h3>
				        </div>
		            <% } else if (status.equals(OrderStatus.Delivered)) { %> 
		                <div class="status-delivered">
				            <h3>Delivered</h3>
				        </div>
		            <% } else if (status.equals(OrderStatus.Cancelled)) { %> 
		                <div class="status-cancelled">
				            <h3>Cancelled</h3>
				        </div>
		            <% } %>  
	            </td>
	            <td>
	              <h4>₹ <%= String.format("%.2f", order.getTotal_amount()) %></h4>
	            </td>
	            <td>
	                <div class="buttons">
	                	<form action="/admin/dashboard/order/update/<%= order.getId() %>" method="post">
	                		<button class="update" type="submit">Update Status</button>
	                	</form>	                    
	                    <form action="/admin/dashboard/order/cancel/<%= order.getId() %>" method="post">
	                    	<button class="cancel" type="submit">Cancel Order</button>
	                    </form>	                    
	                </div>
	            </td>
	          </tr>
          <% } %>
        <% } %>
        </tbody>
      </table>
    </div>
  </body>
</html>
