<%-- 
    Document   : Pedido
    Created on : 26 jun. 2026, 10:54:09 a. m.
    Author     : docente
--%>
<%@page import="Modelo.Detalle"%>
<%@page import="Modelo.Pedido"%>
<%@page import="Controlador.Admin_Pedidos"%>
<%@page import="Modelo.Cliente"%>
<%@page import="Controlador.Admin_Clientes"%>
<%@page import="java.util.ArrayList"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Pedido</title>

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

        .encabezado{
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 25px;
        }

        .grupo-form{
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 25px;
            align-items: flex-start;
        }

        .campo{
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        label{
            font-weight: bold;
            color: #334155;
        }

        select, input[type="date"], input[type="text"]{
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            background: #f8fafc;
            outline: none;
        }

        select{
            min-width: 260px;
        }

        input[readonly]{
            background: #e2e8f0;
            font-weight: bold;
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

        .btn-guardar{
            background: #16a34a;
            color: white;
        }

        .btn-catalogo{
            background: #2563eb;
            color: white;
        }

        .btn-index{
            background: #334155;
            color: white;
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

        .link-eliminar{
            text-decoration: none;
            color: #dc2626;
            font-weight: bold;
        }

        .link-eliminar:hover{
            text-decoration: underline;
        }

        .fila-totales td{
            background: #e2e8f0;
            font-weight: bold;
        }

        .acciones{
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 25px;
        }
    </style>
</head>
<body>
    <div class="contenedor">
        <form action="Pedido.jsp" method="post">

            <%
                Admin_Clientes AdmClie = new Admin_Clientes();
                ArrayList<Cliente> lstClientes = new ArrayList<>();

                Admin_Pedidos AdmPed = new Admin_Pedidos();
                int nroPed = 0;

                ArrayList<Detalle> DetallePed = new ArrayList<>();
                int R = -1;
                Pedido Ped = new Pedido();
            %>

            <%
                // Cargar detalles del pedido desde sesión
                DetallePed = (ArrayList<Detalle>) session.getAttribute("DetallePed");
                if (DetallePed == null) {
                    DetallePed = new ArrayList<Detalle>();
                }

                // Cargar clientes
                lstClientes = AdmClie.getClientes();

                // Guardar pedido
                if (request.getParameter("btnGP") != null) {
                    nroPed = AdmPed.UltimoPedido() + 1;
                    String sFecha = request.getParameter("FPedido");
                    String idCliente = request.getParameter("lstClientes");

                    if (DetallePed.isEmpty()) {
                        out.println("<script>alert('No hay productos en el pedido');</script>");
                    } else if (sFecha == null || sFecha.isEmpty()) {
                        out.println("<script>alert('Debe ingresar la fecha del pedido');</script>");
                    } else if (idCliente == null || idCliente.isEmpty()) {
                        out.println("<script>alert('Debe seleccionar un cliente');</script>");
                    } else {
                        java.sql.Date FechaPed = java.sql.Date.valueOf(sFecha);

                        Ped = new Pedido(nroPed, idCliente, 1, FechaPed);
                        R = AdmPed.guardarPedido(Ped);

                        if (R > 0) {

                            // Asignar el número de pedido a cada detalle
                            for (Detalle d : DetallePed) {
                                d.setIdPedido(nroPed);
                            }

                            R = AdmPed.guardarDetalles(DetallePed);

                            if (R > 0) {
                                session.removeAttribute("DetallePed");
                                DetallePed = new ArrayList<Detalle>();
                                out.println("<script>alert('Pedido guardado exitosamente');</script>");
                            } else {
                                out.println("<script>alert('No se pudieron guardar los detalles del pedido');</script>");
                            }

                        } else {
                            out.println("<script>alert('No se pudo guardar la cabecera del pedido');</script>");
                        }
                    }
                }
            %>

            <div class="encabezado">
                <h1>Pedido</h1>
            </div>

            <div class="grupo-form">
                <div class="campo">
                    <label for="lstClientes">Clientes:</label>
                    <select name="lstClientes" id="lstClientes" size="5">
                        <%
                            for (int n = 0; n < lstClientes.size(); ++n) {
                        %>
                        <option value="<%=lstClientes.get(n).getIdCliente()%>">
                            <%=lstClientes.get(n).getNombreEmpresa()%>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="campo">
                    <label for="FPedido">Fecha de Pedido:</label>
                    <input type="date" id="FPedido" name="FPedido" required>
                </div>

                <div class="campo">
                    <label for="NroPedido">Nro. de Pedido Registrado:</label>
                    <input type="text" id="NroPedido" name="NroPedido" value="<%=nroPed%>" readonly>
                </div>
            </div>

            <div class="tabla-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>PRODUCTO</th>
                            <th>DESCRIPCIÓN</th>
                            <th>PRECIO</th>
                            <th>CANTIDAD</th>
                            <th>IMP.COMP.</th>
                            <th>IMP.DSCTO</th>
                            <th>IMP.PAGO</th>
                            <th>ELIMINAR</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            double ImpComp = 0;
                            double ImpDscto = 0;
                            double ImpPago = 0;

                            double TotComp = 0;
                            double TotDscto = 0;
                            double TotPago = 0;

                            for (int n = 0; n < DetallePed.size(); n++) {

                                ImpComp = DetallePed.get(n).getPrecioUnidad() * DetallePed.get(n).getCantidad();
                                ImpDscto = ImpComp * DetallePed.get(n).getDescuento();
                                ImpPago = ImpComp - ImpDscto;

                                TotComp += ImpComp;
                                TotDscto += ImpDscto;
                                TotPago += ImpPago;
                        %>
                        <tr>
                            <td><%=DetallePed.get(n).getIdProducto()%></td>
                            <td><%=DetallePed.get(n).getProducto()%></td>
                            <td><%=DetallePed.get(n).getUndMed()%></td>
                            <td><%=String.format("%.2f", DetallePed.get(n).getPrecioUnidad())%></td>
                            <td><%=DetallePed.get(n).getCantidad()%></td>
                            <td><%=String.format("%.2f", ImpComp)%></td>
                            <td><%=String.format("%.2f", ImpDscto)%></td>
                            <td><%=String.format("%.2f", ImpPago)%></td>
                            <td>
                                <a href="EliminarDetalle.jsp?fila=<%=n%>" class="link-eliminar">
                                    Eliminar
                                </a>
                            </td>
                        </tr>
                        <%
                            }
                        %>

                        <tr class="fila-totales">
                            <td colspan="5"><b>TOTALES</b></td>
                            <td><b><%=String.format("%.2f", TotComp)%></b></td>
                            <td><b><%=String.format("%.2f", TotDscto)%></b></td>
                            <td><b><%=String.format("%.2f", TotPago)%></b></td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="acciones">
                <input type="submit" name="btnGP" value="Guardar Pedido" class="btn btn-guardar">

                <button type="button" class="btn btn-catalogo" onclick="window.location.href='Catalogo.jsp'">
                    Catálogo
                </button>

                <button type="button" class="btn btn-index" onclick="window.location.href='index.html'">
                    Inicio
                </button>
            </div>
        </form>
    </div>
</body>
</html>


