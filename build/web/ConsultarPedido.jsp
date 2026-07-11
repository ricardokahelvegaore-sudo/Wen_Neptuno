<%-- 
    Document   : ConsultarPeedido
    Created on : 9 jul. 2026, 6:20:06 p. m.
    Author     : juanc
--%>
<%@page import="Modelo.Detalle"%>
<%@page import="Modelo.Pedido"%>
<%@page import="Controlador.Admin_Pedidos"%>
<%@page import="Controlador.Conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Consultar Pedido</title>

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
            max-width: 1200px;
            margin: auto;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.25);
            padding: 30px;
        }

        h1{
            color: #0f172a;
            font-size: 32px;
            margin-bottom: 25px;
        }

        h2{
            color: #0f172a;
            margin-top: 25px;
            margin-bottom: 15px;
            font-size: 24px;
        }

        .form-buscar{
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .fila-form{
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 12px;
        }

        label{
            font-weight: bold;
            color: #334155;
        }

        .input-buscar{
            padding: 10px 14px;
            font-size: 14px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            width: 240px;
            outline: none;
            background: white;
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
            color: white;
        }

        .btn:hover{
            transform: translateY(-2px);
            opacity: 0.95;
        }

        .buscar-btn{
            background: #2563eb;
        }

        .btn-pedido{
            background: #16a34a;
        }

        .btn-inicio{
            background: #334155;
        }

        .acciones{
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        .mensaje-error{
            color: #991b1b;
            font-weight: bold;
            padding: 14px;
            background: #fee2e2;
            border-left: 5px solid #dc2626;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .mensaje-exito{
            color: #166534;
            font-weight: bold;
            padding: 14px;
            background: #dcfce7;
            border-left: 5px solid #16a34a;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .datos-pedido{
            background: #f8fafc;
            padding: 20px;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            margin-top: 20px;
        }

        .datos-pedido p{
            margin: 10px 0;
            font-size: 15px;
            color: #1f2937;
        }

        .tabla-wrap{
            overflow-x: auto;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            margin-top: 20px;
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

        .total-fila td{
            background: #e2e8f0;
            font-weight: bold;
            font-size: 15px;
        }

        .total-importe{
            color: #16a34a;
            font-size: 16px;
        }

        .sin-detalles{
            text-align: center;
            color: #64748b;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="contenedor">
        <h1>Consultar Pedido</h1>

        <div class="form-buscar">
            <form action="ConsultarPedido.jsp" method="post">
                <div class="fila-form">
                    <label for="txtPedido">Número de Pedido:</label>
                    <input type="number" class="input-buscar"
                           id="txtPedido" name="txtPedido"
                           placeholder="Ingrese el ID del pedido" required>
                    <input type="submit" class="btn buscar-btn" value="Buscar" name="btnBuscar">
                </div>
            </form>
        </div>

        <%
            if (request.getParameter("btnBuscar") != null) {
                String paramId = request.getParameter("txtPedido");
                if (paramId != null && !paramId.isEmpty()) {
                    try {
                        int id = Integer.parseInt(paramId);
                        Connection con = Conexion.getConexion();

                        PreparedStatement pstPed = con.prepareStatement(
                            "SELECT * FROM pedido WHERE IdPedido = ?"
                        );
                        pstPed.setInt(1, id);
                        ResultSet rsPed = pstPed.executeQuery();

                        if (rsPed.next()) {
                            out.println("<p class='mensaje-exito'>Pedido encontrado correctamente</p>");

                            out.println("<div class='datos-pedido'>");
                            out.println("<h2>Datos del Pedido</h2>");
                            out.println("<p><strong>ID Pedido:</strong> " + rsPed.getInt("IdPedido") + "</p>");
                            out.println("<p><strong>ID Cliente:</strong> " + rsPed.getString("IdCliente") + "</p>");
                            out.println("<p><strong>ID Empleado:</strong> " + rsPed.getInt("IdEmpleado") + "</p>");
                            out.println("<p><strong>Fecha:</strong> " + rsPed.getDate("FechaPedido") + "</p>");
                            out.println("</div>");
                            rsPed.close();
                            pstPed.close();

                            PreparedStatement pstDet = con.prepareStatement(
                                "SELECT d.*, p.NombreProducto, p.CantidadPorUnidad " +
                                "FROM detalles_de_pedido d " +
                                "INNER JOIN producto p ON d.IdProducto = p.IdProducto " +
                                "WHERE d.IdPedido = ?"
                            );
                            pstDet.setInt(1, id);
                            ResultSet rsDet = pstDet.executeQuery();

                            out.println("<h2>Detalles del Pedido</h2>");
                            out.println("<div class='tabla-wrap'>");
                            out.println("<table>");
                            out.println("<thead><tr>");
                            out.println("<th>ID Producto</th>");
                            out.println("<th>Producto</th>");
                            out.println("<th>Descripción</th>");
                            out.println("<th>Precio Unit.</th>");
                            out.println("<th>Cantidad</th>");
                            out.println("<th>Descuento</th>");
                            out.println("<th>Importe</th>");
                            out.println("</tr></thead><tbody>");

                            double total = 0;
                            boolean hayDetalles = false;

                            while (rsDet.next()) {
                                hayDetalles = true;
                                double precio = rsDet.getDouble("PrecioUnidad");
                                int cantidad = rsDet.getInt("Cantidad");
                                double descuento = rsDet.getDouble("Descuento");
                                double imp = precio * cantidad;
                                double desc = imp * descuento;
                                double totalLinea = imp - desc;
                                total += totalLinea;

                                out.println("<tr>");
                                out.println("<td>" + rsDet.getInt("IdProducto") + "</td>");
                                out.println("<td>" + rsDet.getString("NombreProducto") + "</td>");
                                out.println("<td>" + rsDet.getString("CantidadPorUnidad") + "</td>");
                                out.println("<td>" + String.format("%.2f", precio) + "</td>");
                                out.println("<td>" + cantidad + "</td>");
                                out.println("<td>" + String.format("%.0f", descuento * 100) + "%</td>");
                                out.println("<td>" + String.format("%.2f", totalLinea) + "</td>");
                                out.println("</tr>");
                            }

                            if (!hayDetalles) {
                                out.println("<tr><td colspan='7' class='sin-detalles'>No hay detalles para este pedido</td></tr>");
                            }

                            out.println("<tr class='total-fila'>");
                            out.println("<td colspan='6' style='text-align:right;'>TOTAL</td>");
                            out.println("<td class='total-importe'>" + String.format("%.2f", total) + "</td>");
                            out.println("</tr>");

                            out.println("</tbody></table>");
                            out.println("</div>");

                            rsDet.close();
                            pstDet.close();
                        } else {
                            out.println("<p class='mensaje-error'>No se encontró el pedido con ID: " + id + "</p>");
                        }

                        con.close();

                    } catch (NumberFormatException e) {
                        out.println("<p class='mensaje-error'>Ingrese un número válido</p>");
                    } catch (Exception e) {
                        out.println("<p class='mensaje-error'>Error al buscar: " + e.getMessage() + "</p>");
                        e.printStackTrace(response.getWriter());
                    }
                }
            }
        %>

        <div class="acciones">
            <button type="button" class="btn btn-pedido" onclick="window.location.href='Pedido.jsp'">
                Volver a Pedidos
            </button>

            <button type="button" class="btn btn-inicio" onclick="window.location.href='index.html'">
                Inicio
            </button>
        </div>
    </div>
</body>
</html>

