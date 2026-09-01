# Agenda de Contatos — Aula 09 (Opção 1)

Este projeto foi desenvolvido como resolução do **Exercício Prático da Aula 09 - Desenvolvimento para Ambientes Móveis (Faculdade COTEMIG 2026.2)**.

## Opção Escolhida
- **Opção 1 — Agenda de Contatos**

## Funcionalidades
- **Formulário de Cadastro**: Validação de Nome, E-mail e Telefone utilizando expressões regulares (`RegExp`).
- **Gestão de Estado**: Atualização em tempo real da lista de contatos e do status de favorito via `setState`.
- **Exibição Dinâmica**: Lista construída com `ListView.builder`, utilizando `Card`, `ListTile` e `CircleAvatar`.
- **Favorito por Item**: Ícone de coração iterativo que alterna entre marcado/desmarcado.
- **Contador no AppBar**: O título do `AppBar` exibe o total de contatos cadastrados.
- **Estado Vazio**: Mensagem informativa exibida quando a lista não possui contatos.
- **Feedback Visual**: Exibição de `SnackBar` de sucesso ao cadastrar.

## Checklist de Entrega

- [x] Indicar a opção escolhida (Opção 1 — Agenda de Contatos)
- [x] App roda sem nenhum erro vermelho
- [x] Form com GlobalKey e validate()
- [x] Mínimo 3 TextFormField com dispose()
- [x] Mínimo 2 validators com RegExp
- [x] SnackBar de sucesso implementado
- [x] Mínimo 2 setState no código
- [x] Sem overflow em nenhuma tela
- [x] Checklist incluída na documentação
