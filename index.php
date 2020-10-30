<?php

/*
=====================================================
 Главный обработчик
 -------------------------------------
 Файл: index.php
=====================================================
*/

#Выключаем оповещения об ошибках
error_reporting( 0 );

date_default_timezone_set ( 'Europe/Moscow' );

mb_internal_encoding( 'UTF-8' );

define( 'ROOT_DIR', __DIR__ );

# Подключаем все требуемые файлы
require ROOT_DIR . '/config/db.php';
require ROOT_DIR . '/modules/functions.php';
require ROOT_DIR . '/classes/template.class.php';

# Начинаем сессию
session_start();

$system = [];

# Проверяем авторизован ли пользователь и выдергиваем информацию о нем из базы
if ( isset( $_SESSION['logged_user'] ) ) {

    $query = $database->prepare( 'SELECT * FROM users WHERE id = ?' );
    $query->execute( [ intval( $_SESSION['logged_user'] ) ] );

    if ( !$system['user_data'] = $query->fetch() ) {
      unset( $_SESSION['logged_user'] );
    }

}

if ( isset( $_GET['page'] ) ) {
  $system['page'] = $_GET['page'];
}
else {
  $system['page'] = '';
}

if ( isset( $_GET['subdata'] ) ) {
  $system['subdata'] = $_GET['subdata'];
}

if ( isset( $_GET['subpage'] ) ) {
  $system['subpage'] = $_GET['subpage'];
}

$titles = [

  'teachers' => 'Список преподавателей', 'students' => 'Наши студенты', 'items' => 'Доступные предметы',
  'search' => 'Поиск по файлам', 'rating' => 'Рейтинг обучающихся', 'profile' => 'Мой профиль',
  'manager' => 'Менеджер объектов', 'login' => 'Авторизация'

];

$system['title'] = [];

foreach ( $titles as $page => $title ) {

  if ( $system['page'] == $page ) {
    $system['title'][] = $title;
  }

}

if ( !$system['title'] AND !empty( $system['page'] ) ) {
  $system['title'][] = 'Страница потерялась';
}

$system['title'][] = 'Курсы от CourseBox';
$system['title'] = implode( ' - ', $system['title'] );

# Обработчик страниц
if ( !empty( $system['page'] ) ) {

  switch ( $system['page'] ) {

    case 'login':

      require_once ROOT_DIR . '/modules/login.php';

    break;

    case 'profile':

      require_once ROOT_DIR . '/modules/profile.php';

    break;

    case 'logout':

      # Разрушаем сесси при выходе из аккаунта
      if ( isset( $_SESSION['logged_user'] ) ) {

        unset( $_SESSION['logged_user'] );
        header('Location: /');

        exit();

      }
      else {

        header('HTTP/1.1 403 Forbidden');
        header('Location: /');

        exit();

      }

    break;

    case 'items':

      $tpl = new Template;
      $page = $tpl->load('items.tpl')->compile();

    break;

    case 'rating':

      $tpl = new Template;
      $page = $tpl->load('rating.tpl')->compile();

    break;

    case 'students':

      require ROOT_DIR . '/modules/students.php';

    break;

    case 'teachers' :

      require ROOT_DIR . '/modules/teachers.php';

    break;

    case 'manager' :

      require ROOT_DIR . '/modules/manager.php';

    break;

    case 'search':

    require ROOT_DIR . '/modules/search.php';

    $tpl = new Template;

    $tpl->load( 'search.tpl' );

    if ( $search_results ) {
      $tpl->set( '{results}', $search_results );
    }
    else {
      $tpl->set( '{results}', '' );
    }

    $page = $tpl->compile();

    break;

    default:

      # Отдаем 404 и информацию об ошибке
      header( 'HTTP/1.1 404 Not Found' );

      $page = returnInformationBox(
        'Ничего не найдено',
        'Похоже, что данной страницы не существует, либо она скрыта для вас. Перейти на <a href="/">главную</a> страницу',
        'fas fa-search'
      );

    break;

  }

}
else {

  # Если нет страницы то выводим главную
  $body = new Template;
  $page = $body->load('main.tpl')->compile();

}

# Начинаем строить главный шаблон
$tpl = new Template;

$cover = $tpl->load( 'cover.body.tpl' )->set( '{body}', $page )->compile();

#Если пользователь не использует AJAX то выводим полный шаблон
if ( !isset( $_REQUEST['ajax'] ) ) {

  # Выводим результат
  echo $tpl->load( 'cover.tpl' )
  ->set( '{login}', returnPopUpProfile() )
  ->set( '{title}', $system['title'] )
  ->set( '{body}', $cover )
  ->compile();

}
else {

  # Если AJAX запрос то в любом случае отдаем успешное выполнение запроса
  header( 'HTTP/1.1 200 OK' );

  # Выводим требуемую страницу
  echo json_encode( [ 'page' => $cover, 'title' => $system['title'] ] );

  #Добавим небольшую задержку для имитации реальной загрузки (по инернету)
  usleep( 300000 );

}


 ?>
