<?php
/**
 * @file
 * Build a list of drush aliases by identifying drupal directories.
 *
 * Edit the initial variables to match your system's settings.
 */

/**
 * Define your environment hosting variables.
 */
$root = "/www";   // The web root directory.
$base_url = "localhost";    // The base URL to form the web path.
$identifier = "sites/default/settings.php";   // The file used to identify whether a directory is a drupal instance.

// Get the contents of the web root directory.
$contents = scandir($root);

// For every entry, verify that it is a directory and then that it is a drupal instance.
foreach ($contents as $item) {
  if (is_dir("$root/$item")) {
    if (file_exists("$root/$item/$identifier")) {
      $aliases[$item]['root'] = "$root/$item";
      $aliases[$item]['uri'] = "$base_url/$item";
    }
  }
}
