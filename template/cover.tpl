<!doctype html>
<html lang="ru">
  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">

    <title>{title}</title>

    <link rel="stylesheet" href="/template/assets/bootstrap.min.css">
    <link rel="stylesheet" href="/template/assets/webfonts/fa.min.css">
    <link rel="stylesheet" href="/template/assets/animate.css">
    <link rel="icon" type="image/png" href="/template/images/logo.png" />
    <script src="/template/assets/jquery.js"></script>

  </head>
  <body>
    <div class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom shadow-sm">
    <a href="/" class="my-0 mr-md-auto text-primary h4 text-dark text-decoration-none" data-link="ajax">
      <img src="/template/images/logo.png" width="25px" height="25px" alt="">
      CourseBox
    </a>
  <nav class="my-2 my-md-0 mr-md-3">
    <a class="p-2 text-dark text-decoration-none" href="/items" data-link="ajax">Предметы </a>
    <a class="p-2 text-dark text-decoration-none" href="/teachers" data-link="ajax">Список преподавателей</a>
    <a class="p-2 text-dark text-decoration-none" href="/students" data-link="ajax">Наши студенты</a>
    <a class="p-2 text-dark text-decoration-none" href="/rating" data-link="ajax">Успеваемость</a>
  </nav>
  <div class="d-flex">
    <a class="btn btn-primary mr-2 d-inline-block" href="/search" data-link="ajax"><i class="fas fa-search"></i></a>
    {login}
  </div>
</div>

<div id="result">
  {body}
</div>

<div class="container">
  <footer class="pt-4 mt-5 my-md-5 pt-md-5 border-top">
  <div class="row">
  <div class="col-12 col-md">
  <a href="/" class="text-decoration-none" data-link="ajax">
    <img class="mr-1" src="/template/images/logo.png" width="25px" height="25px" alt="">
    <span class="text-dark">CourseBox</span>
  </a>
  <small class="d-block mt-4 mb-3 text-muted mr-2">© 2017-2020 - Все права защищены</small>
  </div>
  <div class="col-6 col-md">
  <h5>Профессии</h5>
  <ul class="list-unstyled text-small">
    <li><a class="text-muted" href="#">Разработчик ПО</a></li>
    <li><a class="text-muted" href="#">Аналитик</a></li>
    <li><a class="text-muted" href="#">Дизайнер </a></li>
    <li><a class="text-muted" href="#">Музыкант</a></li>
  </ul>
  </div>
  <div class="col-6 col-md">
  <h5>Предметы</h5>
  <ul class="list-unstyled text-small">
    <li><a class="text-muted" href="#">Экономика</a></li>
    <li><a class="text-muted" href="#">Программирование на C#</a></li>
    <li><a class="text-muted" href="#">Электронная музыка</a></li>
    <li><a class="text-muted" href="#">UI Дизайн (Photoshop)</a></li>
      <li><a class="text-muted" href="#">Аналитика в MS Exel</a></li>
  </ul>
  </div>
  <div class="col-6 col-md">
  <h5>Помощь</h5>
  <ul class="list-unstyled text-small">
    <li><a class="text-muted" href="#">Контакты</a></li>
    <li><a class="text-muted" href="#">Политика конфиденциальности</a></li>
    <li><a class="text-muted" href="#">FAQ</a></li>
  </ul>
  </div>
  </div>
  </footer>

</div>
</body>

<script src="/template/assets/popper.min.js"></script>
<script src="/template/assets/bootstrap.bundle.min.js"></script>
<script src="/template/assets/bs-custom-file-input.min.js"></script>

<style media="screen">

  .border-separator{
    border-width: 4px !important;
  }

  .loading {
  	background-color: #ffffff;
  	position: fixed;
  	top: 0;
  	left: 0;
  	right: 0;
  	bottom: auto;
  	width: 100%;
  	height: 3px;
    z-index: 99999;
  }

  .loading:before {
  	content: "";
  	position: absolute;
  	left: 0%;
  	top: 0%;
  	background: linear-gradient(45deg, #2196F3 0%, #3385ea 100%);
  	height: 100%;
  }

  .loading:before {
  	animation: loading 0.8s infinite linear;
  }

  @keyframes loading {
  	0% {
  		right: 100%;
  		left: 0;
  	}
  	50% {
  		right: 0%;
  		left: 0;
  	}
  	100% {
  		left: 100%;
  		right: 0;
  	}
  }

</style>

<script type="text/javascript">

$( function () {

  function sendRequest( page ) {

    window.loading = 1;

    $( '.loading' ).remove();
    $( 'body' ).prepend( '<div class="loading"></div>' );

    $.getJSON( page + '?ajax' ).always( function( data ) {

      $( '.loading' ).remove();

      $( 'title' ).html( data.title );
      $( '#result' ).html( data.page );

      $( 'body, html' ).scrollTop( 0 );

      window.loading = 0;

      bsCustomFileInput.init();

    });

  }

  function historyAPI( event ) {

    sendRequest( ( event.state && event.state.page ) || '' );

  }

  $( 'body' ).on( 'click', 'a[data-link="ajax"]', function ( event ) {

    event.stopPropagation();
    event.preventDefault();

    let page = $( this ).attr( 'href' );

    if ( window.loading !== 1 ) {

      history.pushState( { page: page }, '', page );
      sendRequest( page );

    }

  });

  window.onpopstate = historyAPI;

});

</script>
</html>
