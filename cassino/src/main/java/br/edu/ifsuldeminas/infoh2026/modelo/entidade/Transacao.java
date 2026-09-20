/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.edu.ifsuldeminas.infoh2026.modelo.entidade;

import java.sql.Date;

/**
 *
 * @author 12409864678
 */
public class Transacao {
    private Integer id_transacao;
    private double valor;
    private String tipo;
    private Date data;
    private Usuario usuario = new Usuario();

    public Integer getId_transacao() {
        return id_transacao;
    }

    public void setId_transacao(Integer id_transacao) {
        this.id_transacao = id_transacao;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    
    
}
