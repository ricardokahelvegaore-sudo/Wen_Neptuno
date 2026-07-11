<%-- 
    Document   : Catalogo
    Created on : 23 jun. 2026, 12:39:00 p. m.
    Author     : docente
--%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.Detalle"%>}
<%@page import="Controlador.Admin_Pedidos"%>
<%@page import="Controlador.Admin_Productos"%>
<%@page import="Modelo.Categoria"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Controlador.Admin_Categorias"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Catalogo</title>

    <style>
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        body{
            background: linear-gradient(135deg, #0f172a, #1e293b);
            min-height: 100vh;
            padding: 30px;
        }

        .contenedor{
            max-width: 1150px;
            margin: auto;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.25);
            padding: 30px;
        }

        .encabezado{
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 25px;
        }

        h1{
            color: #0f172a;
            font-size: 32px;
        }

        .fila-form{
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        label{
            font-weight: bold;
            color: #334155;
        }

        select{
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            background: #f8fafc;
            min-width: 230px;
            outline: none;
        }

        .btn{
            border: none;
            padding: 11px 18px;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.25s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover{
            transform: translateY(-2px);
            opacity: 0.95;
        }

        .btn-home{
            background: #334155;
            color: white;
        }

        .btn-ver{
            background: #2563eb;
            color: white;
        }

        .btn-add{
            background: #16a34a;
            color: white;
            margin-top: 18px;
        }

        .btn-pedido{
            background: #f59e0b;
            color: white;
            margin-top: 18px;
        }

        .tabla-wrap{
            overflow-x: auto;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
        }

        table{
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        thead{
            background: #0f172a;
        }

        th{
            color: white;
            padding: 14px 12px;
            text-align: center;
            font-size: 15px;
        }

        td{
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #e5e7eb;
            color: #1f2937;
        }

        tbody tr:nth-child(even){
            background-color: #f8fafc;
        }

        tbody tr:hover{
            background-color: #e0f2fe;
        }

        input[type="number"]{
            width: 80px;
            padding: 8px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            text-align: center;
            outline: none;
        }

        .acciones{
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 18px;
        }
    </style>
</head>
<body>
    <div class="contenedor">
        <form action="Catalogo.jsp" method="post">
            <%
                Admin_Categorias admCats = new Admin_Categorias();
                ArrayList<Categoria> lstCats = admCats.getCategorias();

                Admin_Productos admProds = new Admin_Productos();
                ArrayList<Producto> lstProds = new ArrayList<>();

                ArrayList<Detalle> DetallePed = new ArrayList<>();

                if (session.getAttribute("DetallePed") != null) {
                    DetallePed = (ArrayList<Detalle>) session.getAttribute("DetallePed");
                }

                int idCat = 0;
                String paramCategoria = request.getParameter("cboCategorias");

                if (paramCategoria != null && !paramCategoria.isEmpty()) {
                  idCat = Integer.parseInt(paramCategoria);
                  lstProds = admProds.getProductos(idCat);
                }
                
            %>

            <div class="encabezado">
                <h1>Catálogo de Productos</h1>
                <a href="index.html" class="btn btn-home">⬅ Volver al Inicio</a>
            </div>

            <div class="fila-form">
                <label for="cboCategorias">Categorías:</label>
                <select name="cboCategorias" id="cboCategorias">
                    <% for (int n = 0; n < lstCats.size(); ++n) { %>
                        <option value="<%=lstCats.get(n).getIdCategoria()%>">
                            <%=lstCats.get(n).getCategoria()%>
                        </option>
                    <% } %>
                </select>

                <input type="submit" value="Ver Productos" name="btnVerProductos" class="btn btn-ver" />
            </div>

            <div class="tabla-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>PRODUCTO</th>
                            <th>DESCRIPCIÓN</th>
                            <th>PRECIO</th>
                            <th>STOCK</th>
                            <th>PEDIDO</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (lstProds != null && !lstProds.isEmpty()) {
                                for (int n = 0; n < lstProds.size(); ++n) {
                        %>
                        <tr>
                            <td><%=lstProds.get(n).getIdProducto()%></td>
                            <td><%=lstProds.get(n).getProducto()%></td>
                            <td><%=lstProds.get(n).getUndMed()%></td>
                            <td><%=String.format("%.2f", lstProds.get(n).getPrecio())%></td>
                            <td><%=String.format("%.0f", lstProds.get(n).getExistencia())%></td>
                            <td>
                                <input type="number" name="txtCantPed<%=n%>" value="0" size="5" min="0" />
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="acciones">
                <input type="submit" value="Añadir al Pedido" name="btnAddPed" class="btn btn-add" />
            </div>

       

<%
    String mensajeStock = "";

    if (request.getParameter("btnAddPed") != null && lstProds != null && !lstProds.isEmpty()) {
        for (int n = 0; n < lstProds.size(); n++) {
            String sCant = request.getParameter("txtCantPed" + n);
            if (sCant == null || sCant.trim().isEmpty()) {
                sCant = "0";
            }

            int CantPedido = 0;
            try {
                CantPedido = Integer.parseInt(sCant);
            } catch (NumberFormatException e) {
                CantPedido = 0;
            }

            if (CantPedido > 0) {
                int IdProducto = lstProds.get(n).getIdProducto();
                String Producto = lstProds.get(n).getProducto();
                String UndMed = lstProds.get(n).getUndMed();
                double Precio = lstProds.get(n).getPrecio();
                int Stock = (int) lstProds.get(n).getExistencia();

                // Validar stock antes de agregar
                if (CantPedido > Stock) {
                    mensajeStock += "No se puede registrar el producto <b>" + Producto +
                                    "</b> porque el stock es insuficiente. Stock disponible: " +
                                    Stock + "<br>";
                } else {
                    boolean existe = false;

                    for (Detalle d : DetallePed) {
                        if (d.getIdProducto() == IdProducto) {
                            existe = true;

                            int nuevaCantidad = d.getCantidad() + CantPedido;

                            // Validar si al sumar excede el stock
                            if (nuevaCantidad > Stock) {
                                mensajeStock += "No se puede agregar más del producto <b>" + Producto +
                                                "</b> porque supera el stock disponible. Stock: " +
                                                Stock + "<br>";
                            } else {
                                d.setCantidad(nuevaCantidad);
                            }
                            break;
                        }
                    }

                    // Si no existe en el carrito, recién agregarlo
                    if (!existe) {
                        Detalle LineaDet = new Detalle(
                            0, IdProducto, Precio, CantPedido, 0.10, Producto, UndMed
                        );
                        DetallePed.add(LineaDet);
                    }
                }
            }
        }

        session.setAttribute("DetallePed", DetallePed);
    }
%>

<%
    if (!mensajeStock.equals("")) {
%>
    <div style="margin-top:15px; padding:12px; background:#fee2e2; color:#991b1b; border-left:5px solid #dc2626; border-radius:10px;">
        <%=mensajeStock%>
    </div>
<%
    }
%>





        </form>

        <form action="Pedido.jsp" method="post">
            <input type="submit" value="Ver Pedido" class="btn btn-pedido" />
        </form>
    </div>
</body>
</html>

