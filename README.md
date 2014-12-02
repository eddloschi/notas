# Notas

Aplicação exemplo usada no minicurso de Ruby on Rails que ocorreu de 25/11/2014 até 28/11/2014 no **Instituto Federal de Educação Ciência e Tecnologia do Sudeste de Minas _Campus_ Barbacena**

## Instruções

### Pré-requisitos

* ruby 1.9 ou superior
* sqlite3
* libqtwebkit-dev libqt5webkit5-dev (testes de integração)

### Obtendo e executando a aplicação

```
$ git clone https://github.com/eddloschi/notas.git
$ cd notas
$ bundle
$ rake db:migrate
$ rails s
```

Acesse http://localhost:3000

### Executando os testes

`$ rake test`
