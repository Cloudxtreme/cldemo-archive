<?php

$pagetitle[] = "Services";

print_optionbar_start();

echo("<span style='font-weight: bold;'>Services</span> &#187; ");

$menu_options = array('basic' => 'Basic',
                      'details' => 'Details');

$sql_param = array();
if(isset($vars['state']))
{
  if($vars['state'] == 'up')
  {
    $state = '1';
  }
    elseif($vars['state'] == 'down')
  {
    $state = '0';
  }
}

if ($vars['state'])    {
  $where .= " AND service_status= ?";       $sql_param[] = $state;
  $where .= " AND service_disabled='0' AND `service_ignore`='0'"; $sql_param[] = '';
}
if ($vars['disabled']) { $where .= " AND service_disabled= ?";     $sql_param[] = $vars['disabled']; }
if ($vars['ignore'])   { $where .= " AND `service_ignore`= ?";       $sql_param[] = $vars['ignore']; }
if (!$vars['view']) { $vars['view'] = "basic"; }

$sep = "";
foreach ($menu_options as $option => $text)
{
  if (empty($vars['view'])) { $vars['view'] = $option; }
  echo($sep);
  if ($vars['view'] == $option) { echo("<span class='pagemenu-selected'>"); }
  echo(generate_link($text, $vars, array('view'=>$option)));
  if ($vars['view'] == $option) { echo("</span>"); }
  $sep = " | ";
}

unset($sep);

print_optionbar_end();

echo('<table class="table table-condensed">');
//echo("<tr class=interface-desc bgcolor='#e5e5e5'><td>Device</td><td>Service</td><td>Status</td><td>Changed</td><td>Checked</td><td>Message</td></tr>");

if ($_SESSION['userlevel'] >= '5')
{
  $host_sql = "SELECT * FROM devices AS D, services AS S WHERE D.device_id = S.device_id GROUP BY D.hostname ORDER BY D.hostname";
  $host_par = array();
} else {
  $host_sql = "SELECT * FROM devices AS D, services AS S, devices_perms AS P WHERE D.device_id = S.device_id AND D.device_id = P.device_id AND P.user_id = ? GROUP BY D.hostname ORDER BY D.hostname";
  $host_par = array($_SESSION['user_id']);
}
  foreach (dbFetchRows($host_sql, $host_par) as $device)
  {
    $device_id = $device['device_id'];
    $device_hostname = $device['hostname'];
    array_unshift($sql_param,$device_id);
    foreach (dbFetchRows("SELECT * FROM `services` WHERE `device_id` = ? $where", $sql_param) as $service)
    {
       include("includes/print-service.inc.php");

#       $samehost = 1;
       if ($vars['view'] == "details")
       {
         $graph_array['height'] = "100";
         $graph_array['width']  = "215";
         $graph_array['to']     = $config['time']['now'];
         $graph_array['id']     = $service['service_id'];
         $graph_array['type']   = "service_availability";

         $periods = array('day', 'week', 'month', 'year');

         echo('<tr style="background-color: '.$bg.'; padding: 5px;"><td colspan=6>');

         foreach ($periods as $period)
         {
           $graph_array['from'] = $$period;
           $graph_array_zoom   = $graph_array; $graph_array_zoom['height'] = "150"; $graph_array_zoom['width'] = "400";
           echo(overlib_link("", generate_graph_tag($graph_array), generate_graph_tag($graph_array_zoom),  NULL));
         }
         echo("</td></tr>");
       }
    }
    unset ($samehost);
  }

  echo("</table>");

?>
