<%-- 
    Document   : EliminarDetalle
    Created on : 9 jul. 2026, 6:47:33 p. m.
    Author     : juanc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Modelo.Detalle"%>

<%

ArrayList<Detalle> lista =
(ArrayList<Detalle>)session.getAttribute("DetallePed");

if(lista != null && lista.size() > 0){

    String paramFila = request.getParameter("fila");
    
    if(paramFila != null && !paramFila.isEmpty()){
        try{
            int fila = Integer.parseInt(paramFila);

            if(fila >= 0 && fila < lista.size()){

                lista.remove(fila);

            }
        } catch(NumberFormatException e){
            // Si no se puede parsear, no hacer nada
        }
    }

    session.setAttribute("DetallePed",lista);

}

response.sendRedirect("Pedido.jsp");

%>