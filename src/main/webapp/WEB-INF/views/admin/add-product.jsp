<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">

<div class="container admin-feature-page">

    <div class="form-header">
        <div class="admin-feature-header">
            <span class="admin-breadcrumb">Admin / Products / Add</span>
            <h2 style="text-align: center">Add Product</h2>
        </div>

        <a href="<%= request.getContextPath() %>/admin/products" class="btn back-btn">
            ← Back to Products
        </a>
    </div>


    <div class="form-wrapper">

        <div class="form-card">

            <form action="<%= request.getContextPath() %>/admin/add-product" method="post">


                <div class="form-group">
                    <label>Product Name</label>
                    <input type="text" name="name" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Price</label>
                        <input type="number" name="price" required>
                    </div>

                    <div class="form-group">
                        <label>Stock</label>
                        <input type="number" name="stock" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Category</label>
                    <select name="category">
                        <option>Fruits</option>
                        <option>Vegetables</option>
                        <option>Dairy</option>
                        <option>Snacks</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description"></textarea>
                </div>

                <div class="form-group">
                    <label>Image URL</label>
                    <input type="text" name="imageUrl">
                </div>

                <button type="submit" class="btn primary-btn">Add Product</button>

            </form>

        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
