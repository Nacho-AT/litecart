<?php
  if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
    document::$layout = 'ajax';
  }

  header('X-Robots-Tag: noindex');
  document::$snippets['head_tags']['noindex'] = '<meta name="robots" content="noindex" />';
  document::$snippets['title'][] = language::translate('title_sign_in', 'Sign In');

  breadcrumbs::add(language::translate('title_sign_in', 'Sign In'));

  if (empty($_POST['remember_me'])) $_POST['remember_me'] = false;
  if (empty($_REQUEST['redirect_url'])) $_REQUEST['redirect_url'] = '';

  if (!empty(customer::$data['id'])) notices::add('notice', language::translate('text_already_logged_in', 'You are already logged in'));

  if (!empty($_POST['login'])) {

    try {

      setcookie('customer_remember_me', null, -1, WS_DIR_HTTP_HOME);

      if (empty($_POST['email']) || empty($_POST['password'])) {
        throw new Exception(language::translate('error_missing_login_credentials', 'You must provide both email address and password.'));
      }

      $customer_query = database::query(
        "select * from ". DB_TABLE_CUSTOMERS ."
        where lower(email) = lower('". database::input($_POST['email']) ."')
        limit 1;"
      );

      if (!$customer = database::fetch($customer_query)) {
        throw new Exception(language::translate('error_email_not_found_in_database', 'The email does not exist in our database'));
      }

      if ($customer['password'] != functions::password_checksum($customer['email'], $_POST['password'])) {
        throw new Exception(language::translate('error_wrong_password', 'Wrong password or the account does not exist'));
      }

      if (empty($customer['status'])) {
        throw new Exception(language::translate('error_account_inactive', 'Your account is inactive, contact customer support'));
      }

      if (empty($customer['password'])) {
        $customer['password'] = functions::password_checksum($customer['email'], $_POST['password']);
        database::query(
          "update ". DB_TABLE_CUSTOMERS ."
          set password = '". database::input($customer['password']) ."'
          where id = ". (int)$customer['id'] ."
          limit 1;"
        );
      }

      database::query(
        "update ". DB_TABLE_CUSTOMERS ."
        set num_logins = num_logins + 1,
            last_ip = '". database::input($_SERVER['REMOTE_ADDR']) ."',
            last_host = '". database::input(gethostbyaddr($_SERVER['REMOTE_ADDR'])) ."',
            last_agent = '". database::input($_SERVER['HTTP_USER_AGENT']) ."',
            date_login = '". date('Y-m-d H:i:s') ."'
        where id = ". (int)$customer['id'] ."
        limit 1;"
      );

      customer::load($customer['id']);

      session::regenerate_id();

      if (!empty($customer['last_host']) && $customer['last_host'] != gethostbyaddr($_SERVER['REMOTE_ADDR'])) {
        notices::add('warnings', strtr(language::translate('warning_account_previously_used_by_another_host', 'Your account was previously used by another location or hostname (%hostname). If this was not you then your login credentials might be compromised.'), array('%hostname' => $customer['last_host'])));
      }

      if (!empty($_POST['remember_me'])) {
        $checksum = sha1($customer['email'] . $customer['password'] . PASSWORD_SALT . ($_SERVER['HTTP_USER_AGENT'] ? $_SERVER['HTTP_USER_AGENT'] : ''));
        setcookie('customer_remember_me', $customer['email'] .':'. $checksum, strtotime('+3 months'), WS_DIR_HTTP_HOME);
      }

      if (empty($_REQUEST['redirect_url'])) {
        $_REQUEST['redirect_url'] = document::ilink('');
      }

      notices::add('success', strtr(language::translate('success_logged_in_as_user', 'You are now logged in as %firstname %lastname.'), array(
        '%firstname' => customer::$data['firstname'],
        '%lastname' => customer::$data['lastname'],
      )));

      header('Location: '. $_REQUEST['redirect_url']);
      exit;

    } catch (Exception $e) {
      http_response_code(401);
      notices::add('errors', $e->getMessage());
    }
  }

  $_page = new view();

  if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
    echo $_page->stitch('pages/login.ajax');
  } else {
    echo $_page->stitch('pages/login');
  }
