Uso do aplicativo:

Primeira opção: abra o cmd na pasta do projeto e digite "flutter run"
Segunda opção: crie um terminal no Visual Studio Code, vá até o arquivo main.dart e digite "flutter run"

Tela Principal (Home):

Ao iniciar o aplicativo, você será recebido com uma interface limpa e simples. Na tela principal, há um campo de texto para digitar o CEP que você deseja consultar, um botão de "Consultar", e logo abaixo, o histórico de consultas.

Consulta de CEP:

-Digite um CEP no campo de texto.
-Clique no botão "Consultar" para buscar o endereço correspondente.
-Se o CEP for válido, o endereço será exibido logo abaixo do botão.
-Se o CEP for inválido, uma mensagem de erro será exibida.
-Histórico de Consultas
-O histórico de consultas exibe os endereços que você pesquisou anteriormente. Cada vez que você consulta um CEP, o endereço será adicionado ao histórico.

O histórico é armazenado localmente usando SharedPreferences, então ele será preservado mesmo que o aplicativo seja fechado.

Abrir no Google Maps:

Se você desejar abrir um endereço diretamente no Google Maps:

-Clique em qualquer item do histórico.
-O Google Maps será aberto com a localização correspondente ao endereço clicado.

Tecnologias Utilizadas:

Flutter: Framework para a construção da interface do usuário.
Dart: Linguagem de programação usada com Flutter.
HTTP: Biblioteca para fazer requisições à API ViaCEP.
SharedPreferences: Para armazenamento local do histórico de consultas.
UrlLauncher: Para abrir endereços no Google Maps.