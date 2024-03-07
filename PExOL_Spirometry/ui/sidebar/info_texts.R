info_upload_file_text <- 
  HTML("<p>The uploaded spirometric dataset must be a csv-file containing 
        one or multiple time series and meet the following requirements:
        <ul>
          <li>The dataset must contain exactly four columns named
          <b>ID</b>, <b>Time</b>, <b>Volume</b> and <b>Flow</b>.</li>
          <li>The column <b>ID</b> may contain numeric or character values.
          The other columns must contain only numeric values.</li>
          <li>The units of the individual columns are <i>s</i> for <b>Time</b>,
          <i>l</i> for <b>Volume</b>  and <i>l/s</i> for <b>Flow</b>.</li>
          <li>For each <b>ID</b>, the column <b>Time</b> must be ordered
          in subsequent <i>0.01s</i> intervals.</li>
          <li>The dataset must not contain any missing values.</li>
        </ul></p>")

info_ref_data_background_switch_text <- 
  HTML("<p>The option displays the complete dataset in the background.<br>
       This may significantly slow the rendering process.</p>")

info_starting_trial_text <- 
  HTML("<p>A single trial can be selected as basis for the manipulation.
       Before selecting a new basis, previous manipulation steps have to be reset.</p>
       <p>The manipulation of a selected trial follows an iterative approach:
       <ul>
          <li>The zone to be manipulated must be determined.</li>
          <li>A parameter has to be selected and manipulated.</li>
          <li>The change must be committed permanently by clicking <b>Apply change</b>.</li>
        </ul>
       Each iterative change is displayed by a light right line.</p>")

info_zone_text <- 
  HTML("<p> In the plot, the manipulation zone is displayed by two black, vertical bars.
       The center point of the zone is marked with a black cross.</p>
       <p>Via <b>Show zone</b> the visual display of the zone can be toggled.</p>
       <p>By pushing the <b>Center point</b> slider or clickling inside the plot
        the position of the zone can be adjusted.</p>
       <p>The <b>Range</b> of the zone can be defined by pushing the corresponding slider.</p>")

info_man_time_text <- 
  HTML("<p>The slider displays the current duration of the zone.<br>
       By pushing the slider, the duration can be shortened or extended.</p>")

info_man_vol_flow_text <- 
  HTML("<p>The slider displays the current value of the center point.<br>
       By pushing the slider, the value can be decreased or increased.</p>
       <p>Starting from the center point, all data points of the zone will be
       manipulated depending on the <b>Change function</b>.</p>")

info_animation_text <- 
  HTML("<p>Multiple selections are possible.</p>
       <p>Depending on the available ressources, the rendering and displaying
       of multiple trials at the same time may take an extensive amount of time.</p>")

