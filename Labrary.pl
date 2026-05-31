%============ FATOS =============

%livro(Titulo, Autor, Ano, Categoria)
livro('O Senhor dos Anéis', 'J.R.R. Tolkien', 1954, 'Fantasia').
livro('1984', 'George Orwell', 1949, 'Distopia').
livro('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943, 'Infantil').
livro('Dom Quixote', 'Miguel de Cervantes', 1605, 'Clássico').
livro('A Guerra dos Tronos', 'George R.R. Martin', 1996, 'Fantasia').

%autor(Nome, Nacionalidade)
autor('J.R.R. Tolkien', 'Reino Unido').
autor('George Orwell', 'Reino Unido').
autor('Antoine de Saint-Exupéry', 'França').
autor('Miguel de Cervantes', 'Espanha').
autor('George R.R. Martin', 'Estados Unidos').

%pessoa(Nome, Identificador).
pessoa('Alice', 1).
pessoa('Bob', 2).
pessoa('Charlie', 3).

%emprestado(Titulo, IdentificadorPessoa, DataEmprestimo).
emprestado('O Senhor dos Anéis', 1, '2024-06-01').

%============ PREDICADOS =============

livros_por_autor(Autor, Titulos) :-
    findall(Titulo, livro(Titulo, Autor, _, _), Titulos).

livros_antigos(AnoMaximo, Titulo) :-
    livro(Titulo, _, Ano, _),
    Ano < AnoMaximo.

disponivel(Titulo) :-
    livro(Titulo, _, _, _),
    \+emprestado(Titulo, _, _).

livros_emprestados_por(NomePessoa, Titulo) :-
    pessoa(NomePessoa, Identificador),
    emprestado(Titulo, Identificador, _).

inserir_livros(Titulo, Autor, Ano, Categoria) :-
    assertz(livro(Titulo, Autor, Ano, Categoria)).

emprestar_livros(Titulo, IdentificadorPessoa, DataEmprestimo) :-
    livro(Titulo, _, _, _),
    \+emprestado(Titulo, _, _),
    assertz(emprestado(Titulo, IdentificadorPessoa, DataEmprestimo)).

devolver_livros(Titulo, IdentificadorPessoa) :-
    retract(emprestado(Titulo, IdentificadorPessoa, _)).