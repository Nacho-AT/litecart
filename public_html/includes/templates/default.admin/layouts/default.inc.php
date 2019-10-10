<!DOCTYPE html>
<html lang="{snippet:language}" dir="{snippet:text_direction}">
<head>
<title>{snippet:title}</title>
<meta charset="{snippet:charset}" />
<meta name="robots" content="noindex, nofollow" />
<meta name="viewport" content="width=1600">
{snippet:head_tags}
<link rel="stylesheet" href="{snippet:template_path}css/framework.min.css" />
<link rel="stylesheet" href="{snippet:template_path}css/app.min.css" />
{snippet:style}
</head>
<body>

<div id="backend-wrapper">
  <input id="sidebar-compressed" type="checkbox" hidden />

  <div id="sidebar" class="hidden-print">

    <div id="logotype">
      <a href="<?php echo document::href_link(WS_DIR_ADMIN); ?>">
        <img class="center-block img-responsive" src="<?php echo WS_DIR_TEMPLATE; ?>images/logotype.svg" alt="<?php echo settings::get('store_name'); ?>" />
      </a>
    </div>

    <div id="search" class="container-fluid">
      <?php echo functions::form_draw_search_field('query', false, 'placeholder="'. htmlspecialchars(language::translate('title_search', 'Search')) .'&hellip;"'); ?>
      <div class="results"></div>
    </div>

    {snippet:box_apps_menu}

    <div id="platform" class="text-center"><?php echo PLATFORM_NAME; ?>® <?php echo PLATFORM_VERSION; ?></div>

    <div id="copyright" class="text-center">Copyright &copy; <?php echo date('2012-Y'); ?><br />
      <a href="http://www.litecart.net" target="_blank">www.litecart.net</a>
    </div>
  </div>

  <main id="main">
    <ul id="top-bar" class="hidden-print">
      <li>
        <div>
          <label class="nav-toggle" for="sidebar-compressed" >
            <?php echo functions::draw_fonticon('fa-bars'); ?>
          </label>
        </div>
      </li>

      <li>
        {snippet:breadcrumbs}
      </li>

      <li style="flex-grow: 1;"></li>

      <?php foreach (language::$languages as $language) { ?>
      <?php if (empty($language['status'])) continue; ?>
      <li>
        <a href="<?php echo document::href_link(null, array('language' => $language['code']), true); ?>">
          <img src="<?php echo document::href_link(WS_DIR_APP . 'images/languages/'. $language['code'] .'.png'); ?>" alt="<?php echo $language['code']; ?>" title="<?php echo htmlspecialchars($language['name']); ?>" style="max-height: 1em;" />
        </a>
      </li>
      <?php } ?>

      <li />

<!--
      <li>
        <a href="<?php echo document::href_link(WS_DIR_ADMIN); ?>" title="<?php echo htmlspecialchars(language::translate('title_dashboard', 'Dashboard')); ?>">
          <?php echo functions::draw_fonticon('fa-dashboard'); ?>
        </a>
      </li>
-->


      <?php if (settings::get('webmail_link', '')) { ?>
      <li>
        <a href="<?php echo settings::get('webmail_link'); ?>" target="_blank" title="<?php echo language::translate('title_webmail', 'Webmail'); ?>">
          <?php echo functions::draw_fonticon('fa-envelope'); ?>
        </a>
      </li>
      <?php } ?>

      <?php if (settings::get('database_admin_link')) { ?>
      <li>
        <a href="<?php echo settings::get('database_admin_link'); ?>" target="_blank" title="<?php echo language::translate('title_database_manager', 'Database Manager'); ?>">
          <?php echo functions::draw_fonticon('fa-database'); ?>
        </a>
      </li>
      <?php } ?>

      <li>
        <a href="<?php echo document::href_ilink(''); ?>" title="<?php echo language::translate('title_catalog', 'Catalog'); ?>">
          <?php echo functions::draw_fonticon('fa-shopping-cart'); ?> <?php echo language::translate('title_catalog', 'Catalog'); ?>
        </a>
      </li>

      <li>
        <a class="help" href="{snippet:help_link}" target="_blank" title="<?php echo language::translate('title_help', 'Help'); ?>">
          <?php echo functions::draw_fonticon('fa-question-circle'); ?> <?php echo language::translate('title_help', 'Help'); ?>
        </a>
      </li>

      <li>
        <a href="<?php echo document::href_link(WS_DIR_ADMIN . 'logout.php'); ?>" title="<?php echo language::translate('text_logout', 'Logout'); ?>">
          <?php echo functions::draw_fonticon('fa-sign-out'); ?> <?php echo language::translate('title_sign_out', 'Sign Out'); ?>
        </a>
      </li>

    </ul>

    <div id="content">
      {snippet:notices}
      {snippet:content}
    </div>
  </div>
</div>

{snippet:foot_tags}
<script src="{snippet:template_path}js/app.min.js"></script>
{snippet:javascript}
</body>
</html>