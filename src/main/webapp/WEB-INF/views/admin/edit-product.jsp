<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cartiva.model.Product" %>

<%
    Product product =
    (Product) request.getAttribute("product");
%>

<jsp:include page="../partials/header.jsp" />
<jsp:include page="../partials/navbar.jsp" />

<div class="container admin-feature-page">


    <div class="admin-feature-header">
        <span class="admin-breadcrumb">Admin / Products / Edit</span>
        <h1 class="admin-page-title">
            Edit Product
        </h1>
    </div>


    <a href="<%= request.getContextPath() %>/admin/products"
       class="premium-back-btn">

        ← Back to Products

    </a>


    <div class="premium-form-card">

        <form action="<%= request.getContextPath() %>/admin/edit-product"
              method="post">

            <input type="hidden"
                   name="id"
                   value="<%= product.getProductId() %>">


            <div class="premium-form-grid">


                <div class="premium-input-group">

                    <label>
                        Product Name
                    </label>

                    <input type="text"
                           name="name"
                           value="<%= product.getName() %>"
                           required>

                </div>


                <div class="premium-input-group">

                    <label>
                        Price
                    </label>

                    <input type="number"
                           step="0.01"
                           name="price"
                           value="<%= product.getPrice() %>"
                           required>

                </div>


                <div class="premium-input-group">

                    <label>
                        Category
                    </label>

                    <input type="text"
                           name="category"
                           value="<%= product.getCategory() %>"
                           required>

                </div>


                <div class="premium-input-group">

                    <label>
                        Stock
                    </label>

                    <input type="number"
                           name="stock"
                           value="<%= product.getStockQuantity() %>"
                           required>

                </div>

            </div>


            <div class="premium-input-group full-width">

                <label>
                    Description
                </label>

                <textarea name="description"
                          rows="5"
                          required><%= product.getDescription() %></textarea>

            </div>


            <div class="premium-input-group full-width">

                <label>
                    Image Path
                </label>

                <input type="text"
                       name="image"
                       value="<%= product.getImageUrl() %>"
                       required>

            </div>


            <button type="submit"
                    class="premium-submit-btn">

                Update Product

            </button>

        </form>

    </div>

</div>

<jsp:include page="../partials/footer.jsp" />
