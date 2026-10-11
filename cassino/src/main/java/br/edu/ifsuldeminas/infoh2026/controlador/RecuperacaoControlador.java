package br.edu.ifsuldeminas.infoh2026.controlador;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Iagod
 */
import br.edu.ifsuldeminas.infoh2026.modelo.dao.UsuarioDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Usuario;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.ConnectionFactory; 
import org.mindrot.jbcrypt.BCrypt;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;
import java.util.UUID;

@WebServlet(name = "RecuperacaoControlador", urlPatterns = {"/RecuperacaoControlador"})
public class RecuperacaoControlador extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String opcao = request.getParameter("opcao");

        try {
            if ("enviarEmail".equals(opcao)) {
                processarEnvioEmail(request, response);
            } else if ("alterarSenha".equals(opcao)) {
                processarNovaSenha(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro interno: " + e.getMessage());
            request.getRequestDispatcher("/recuperarSenha.jsp").forward(request, response);
        }
    }

    private void processarEnvioEmail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String email = request.getParameter("email");
        Usuario usuario = usuarioDAO.buscarPorEmail(email);

        if (usuario != null) {
            String token = UUID.randomUUID().toString();
            Timestamp dataExpiracao = new Timestamp(System.currentTimeMillis() + (3600 * 1000));

            try (Connection conn = ConnectionFactory.getIntance().getConnetion();
                 PreparedStatement stmt = conn.prepareStatement("INSERT INTO token_recuperacao (email_usuario, token, data_expiracao, usado) VALUES (?, ?, ?, false)")) {
                stmt.setString(1, email);
                stmt.setString(2, token);
                stmt.setTimestamp(3, dataExpiracao);
                stmt.executeUpdate();
            }

            enviarEmail(email, token, request);
            
            request.setAttribute("mensagem", "Se o e-mail existir, um link de recuperação foi enviado.");
        } else {
            request.setAttribute("mensagem", "Se o e-mail existir, um link de recuperação foi enviado.");
        }
        request.getRequestDispatcher("/recuperarSenha.jsp").forward(request, response);
    }

    private void processarNovaSenha(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String token = request.getParameter("token");
        String novaSenha = request.getParameter("novaSenha");

        String emailUsuario = null;

        // USANDO A SUA CONNECTION FACTORY AQUI:
        try (Connection conn = ConnectionFactory.getIntance().getConnetion();
             PreparedStatement stmt = conn.prepareStatement("SELECT email_usuario FROM token_recuperacao WHERE token = ? AND usado = false AND data_expiracao > NOW()")) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                emailUsuario = rs.getString("email_usuario");
            }
        }

        if (emailUsuario != null) {
            Usuario usuario = usuarioDAO.buscarPorEmail(emailUsuario);
            
            String senhaHash = BCrypt.hashpw(novaSenha, BCrypt.gensalt());
            usuario.setSenha(senhaHash);
            usuarioDAO.alterar(usuario);

            // USANDO A SUA CONNECTION FACTORY AQUI:
            try (Connection conn = ConnectionFactory.getIntance().getConnetion();
                 PreparedStatement stmt = conn.prepareStatement("UPDATE token_recuperacao SET usado = true WHERE token = ?")) {
                stmt.setString(1, token);
                stmt.executeUpdate();
            }

            request.setAttribute("mensagem", "Senha alterada com sucesso! Faça login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("mensagem", "Token inválido, expirado ou já utilizado.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void enviarEmail(String destinatario, String token, HttpServletRequest request) throws Exception {
        // 1. Carrega as configurações do arquivo oculto
        Properties configEmail = new Properties();
        try (InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("email.properties")) {
            if (input == null) {
                throw new Exception("Arquivo email.properties não encontrado em src/main/resources!");
            }
            configEmail.load(input);
        }

        // 2. Pega as variáveis do arquivo
        final String remetente = configEmail.getProperty("email.remetente");
        final String senhaApp = configEmail.getProperty("email.senha");

        // 3. Configura o envio (resto do código igual)
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(remetente, senhaApp);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(remetente));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
        message.setSubject("Recuperação de Senha - Pig Jackpot");
        
        String urlRecuperacao = "http://localhost:8080" + request.getContextPath() + "/novaSenha.jsp?token=" + token;
        
        message.setText("Olá,\n\nVocê solicitou a recuperação de senha.\n"
                + "Clique no link abaixo para criar uma nova senha:\n\n"
                + urlRecuperacao + "\n\n"
                + "Este link expira em 1 hora.\nSe não foi você, ignore este e-mail.");

        Transport.send(message);
    }
}