package br.edu.ifsuldeminas.infoh2026.controlador;

import br.edu.ifsuldeminas.infoh2026.modelo.dao.CarteiraDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.UsuarioConquistaDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Usuario;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.UsuarioConquista;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Carrega os dados da tela de perfil (conquistas do usuário logado)
 * e encaminha para perfil.jsp.
 */
@WebServlet(name = "PerfilControlador", urlPatterns = {"/PerfilControlador"})
public class PerfilControlador extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login");
            return;
        }

        // Só as conquistas do usuário logado
        List<UsuarioConquista> minhas = new ArrayList<>();
        UsuarioConquistaDAO dao = new UsuarioConquistaDAO();
        for (UsuarioConquista uc : dao.buscarTodasUsuarioConquistas()) {
            if (uc.getUsuario() != null
                    && Objects.equals(uc.getUsuario().getId_usuario(), usuario.getId_usuario())) {
                minhas.add(uc);
            }
        }
        request.setAttribute("conquistas", minhas);

        // Carteira do usuário (pode ser null se ainda não fez nenhum depósito)
        request.setAttribute("carteira",
                new CarteiraDAO().buscarCarteiraPorUsuario(usuario.getId_usuario()));

        request.setAttribute("perfilCarregado", true);
        request.getRequestDispatcher("/perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}