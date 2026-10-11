package br.edu.ifsuldeminas.infoh2026.controlador;

import br.edu.ifsuldeminas.infoh2026.modelo.dao.UsuarioDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginControlador", urlPatterns = {"/LoginControlador"})
public class LoginControlador extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String opcao = request.getParameter("opcao");
        
        // Trata o LOGOUT via GET
        if ("logout".equals(opcao)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate(); // Destrói a sessão
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String opcao = request.getParameter("opcao");

        try {
            if ("logar".equals(opcao)) {
                logar(request, response);
            } else if ("cadastrar".equals(opcao)) {
                cadastrar(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro interno: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void logar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        Usuario user = usuarioDAO.buscarPorEmail(email);

        if (user != null && BCrypt.checkpw(senha, user.getSenha())) {
            
            HttpSession session = request.getSession(true);
            user.setSenha(null); // Protege o hash retirando-o da memória
            session.setAttribute("usuarioLogado", user);
            
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            
        } else {
            request.setAttribute("mensagem", "E-mail ou senha incorretos!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void cadastrar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        // 1. VERIFICA SE O E-MAIL JÁ EXISTE NO BANCO!
        Usuario usuarioExistente = usuarioDAO.buscarPorEmail(email);
        if (usuarioExistente != null) {
            // Se encontrou alguém, manda a mensagem de erro e aborta a criação
            request.setAttribute("mensagem", "Erro: O e-mail " + email + " já está cadastrado em nosso sistema.");
            request.getRequestDispatcher("/CadastrarUsuario.jsp").forward(request, response);
            return; // O 'return' encerra o método aqui para ele não ir para a parte de salvar.
        }

        // 2. Se o código chegou aqui, o e-mail está livre. Continua o fluxo normal:
        String nome = request.getParameter("nome");
        String senha = request.getParameter("senha");
        String cpf = request.getParameter("cpf");
        String endereco = request.getParameter("endereco");
        String dataNascimentoStr = request.getParameter("dataNascimento");
        
        Usuario novoUsuario = new Usuario();
        novoUsuario.setNome(nome);
        novoUsuario.setEmail(email);
        novoUsuario.setCpf(cpf);
        novoUsuario.setEndereco(endereco);
        
        if (dataNascimentoStr != null && !dataNascimentoStr.isEmpty()) {
             novoUsuario.setDataNascimento(java.sql.Date.valueOf(dataNascimentoStr));
        }
        novoUsuario.setData_cadastro(new java.sql.Date(System.currentTimeMillis()));
        
        String senhaHash = BCrypt.hashpw(senha, BCrypt.gensalt());
        novoUsuario.setSenha(senhaHash);
        
        try {
            usuarioDAO.salvar(novoUsuario);
            request.setAttribute("mensagem", "Cadastro realizado com sucesso! Faça login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao cadastrar. O CPF pode já estar em uso.");
            request.getRequestDispatcher("/CadastrarUsuario.jsp").forward(request, response);
        }
    }
}