##############################################
# $Id$
package main;

use strict;
use warnings;
use POSIX;
#use List::Util qw[min max];


# R�ume
my $rooms;
  $rooms->{wohnzimmer}->{alias}="Wohnzimmer";
  $rooms->{wohnzimmer}->{fhem_name}="1.01_Wohnzimmer";
  # Definiert nutzbare Sensoren. Reihenfolge gibt Priorit�t an. <= ODER BRAUCHT MAN NUR DIE EINZEL-READING-DEFINITIONEN?
  $rooms->{wohnzimmer}->{sensors}=("wz_raumsensor","wz_wandthermostat","tt_sensor"); 
  $rooms->{wohnzimmer}->{sensors_outdoor}=("hg_sensor"); # Sensoren 'vor dem Fenster'. Wichtig vor allen bei Licht (wg. Sonnenstand)
  # Definiert nutzbare Messwerte einzeln. Hat vorrang vor der Definition von kompletten Sensoren. Reihenfolge gibt Priorit�t an.
  $rooms->{wohnzimmer}->{measurements}->{temperature}=("wz_raumsensor:temperature"); 
  $rooms->{wohnzimmer}->{measurements_outdoor}->{temperature}=("hg_sensor:temperature"); 
  
# Sensoren
my $sensors;
  $sensors->{wz_raumsensor}->{alias}     ="WZ Raumsensor";
  $sensors->{wz_raumsensor}->{fhem_name} ="EG_WZ_KS01";
  $sensors->{wz_raumsensor}->{type}      ="HomeMatic compatible";
  $sensors->{wz_raumsensor}->{location}  ="wohnzimmer";
  $sensors->{wz_raumsensor}->{readings}->{temperature} ->{reading}  ="temperature";
  $sensors->{wz_raumsensor}->{readings}->{temperature} ->{unit}     ="�C";
  $sensors->{wz_raumsensor}->{readings}->{humidity}    ->{reading}  ="humidity";
  $sensors->{wz_raumsensor}->{readings}->{humidity}    ->{unit}     ="�C";
  $sensors->{wz_raumsensor}->{readings}->{pressure}    ->{reading}  ="airpress";
  $sensors->{wz_raumsensor}->{readings}->{pressure}    ->{unit}     ="hPa";
  $sensors->{wz_raumsensor}->{readings}->{luminosity}  ->{reading}  ="luminosity";
  $sensors->{wz_raumsensor}->{readings}->{luminosity}  ->{unit}     ="Lx";
  $sensors->{wz_raumsensor}->{readings}->{bat_voltage} ->{reading}  ="batVoltage";
  $sensors->{wz_raumsensor}->{readings}->{bat_voltage} ->{unit}     ="V";
  $sensors->{wz_raumsensor}->{readings}->{bat_status}  ->{reading}  ="battery";
  
  $sensors->{wz_wandthermostat}->{alias}     ="WZ Wandthermostat";
  $sensors->{wz_wandthermostat}->{fhem_name} ="EG_WZ_WT01";
  $sensors->{wz_wandthermostat}->{type}      ="HomeMatic";
  $sensors->{wz_wandthermostat}->{location}  ="wohnzimmer";
  $sensors->{wz_wandthermostat}->{composite} =("wz_wandthermostat_climate"); # Verbindung mit weitere (logischen) Ger�ten, die eine Einheit bilden.
  $sensors->{wz_wandthermostat}->{readings}        ->{bat_voltage} ->{reading}  ="batteryLevel";
  $sensors->{wz_wandthermostat}->{readings}        ->{bat_voltage} ->{unit}     ="V";
  $sensors->{wz_wandthermostat}->{readings}        ->{bat_status}  ->{reading}  ="battery";
  $sensors->{wz_wandthermostat_climate}->{alias}     ="WZ Wandthermostat";
  $sensors->{wz_wandthermostat_climate}->{fhem_name} ="EG_WZ_WT01_Climate";
  $sensors->{wz_wandthermostat_climate}->{readings}->{temperature} ->{reading}  ="measured-temp";
  $sensors->{wz_wandthermostat_climate}->{readings}->{temperature} ->{unit}     ="�C";
  $sensors->{wz_wandthermostat_climate}->{readings}->{humidity}    ->{reading}  ="humidity";
  $sensors->{wz_wandthermostat_climate}->{readings}->{humidity}    ->{unit}     ="�C";
  
  $sensors->{hg_sensor}->{alias}     ="Garten-Sensor";
  $sensors->{hg_sensor}->{fhem_name} ="GSD_1.4";
  $sensors->{hg_sensor}->{type}      ="GSD";
  $sensors->{hg_sensor}->{location}  ="garten";
  $sensors->{hg_sensor}->{readings}->{temperature} ->{reading}  ="temperature";
  $sensors->{hg_sensor}->{readings}->{temperature} ->{unit}     ="�C";
  $sensors->{hg_sensor}->{readings}->{humidity}    ->{reading}  ="humidity";
  $sensors->{hg_sensor}->{readings}->{humidity}    ->{unit}     ="�C";
  $sensors->{hg_sensor}->{readings}->{bat_voltage}  ->{reading}  ="power_main";
  $sensors->{hg_sensor}->{readings}->{bat_voltage}  ->{unit}     ="V";
  
  $sensors->{tt_sensor}->{alias}     ="Test-Sensor";
  $sensors->{tt_sensor}->{fhem_name} ="GSD_1.1";
  $sensors->{tt_sensor}->{type}      ="GSD";
  $sensors->{tt_sensor}->{location}  ="wohnzimmer";
  $sensors->{tt_sensor}->{readings}->{temperature} ->{reading}  ="temperature";
  $sensors->{tt_sensor}->{readings}->{temperature} ->{unit}     ="�C";
  $sensors->{tt_sensor}->{readings}->{humidity}    ->{reading}  ="humidity";
  $sensors->{tt_sensor}->{readings}->{humidity}    ->{unit}     ="�C";
  $sensors->{tt_sensor}->{readings}->{bat_voltage}  ->{reading}  ="power_main";
  $sensors->{tt_sensor}->{readings}->{bat_voltage}  ->{unit}     ="V";
  
  
my $actTab;
  $actTab->{"schatten"}->{checkFn}="";
  #$actTab->{"schatten"}->{disabled}="0"; #1=disabled, 0, undef,.. => enabled
  #$actTab->{"schatten"}->{deviceList}=(); # undef=> alle in devTab, ansonsten nur angegebenen
  $actTab->{"nacht"}->{checkFn}="";
  $actTab->{"test"}->{checkFn}=undef;

my $devTab;
# Default.
  $devTab->{DEFAULT}->{SetFn}="";
  $devTab->{DEFAULT}->{SetFn}="";
  $devTab->{DEFAULT}->{valueFns}->{"nacht"}="0";
# Badezimmer (Ost)
#oder so?
# $devTab->{"bz_rollo"}->{actions}->{schatten}->{valueFn}="{if...}";
# $devTab->{"bz_rollo"}->{actions}->{schatten}->{value}="80"; # valueFn hat Vorrang, wenn sie undef liefert (oder nicht existiert), dann das hier
# $devTab->{"bz_rollo"}->{actions}->{schatten}->{enabledFn}="{if...}";
# $devTab->{"bz_rollo"}->{actions}->{schatten}->{enabled}="true"; # s.o. 
# $devTab->{"bz_rollo"}->{actions}->{schatten}->{valueFilterFn}="{...}"; #nachdem Wert errechnet wurde, pr�ft nochmal, ob dieser ggf. korrigiert werden soll (Grenzen etc. z.B. bei ge�ffneter T�r 'schatten' max. auf X% herunterfahren. etc.)
# Idee: Mehrere Action durch zwischengeschaltete Keys (mehrfach, alphabetisch sortiert): Idee: Wenn hier ein HASH, dann einzelene ausf�hren, ansonstel ist hier die Fn direkt
# $devTab->{"bz_rollo"}->{actions}->{schatten}->{enabledFn}->{DoorOpenCheck}="{if(sensorVal($CURRENT_DEVICE, wndOpen)!='closed') {...}}"; # DoorOpenCheck ist ein solcher Key.

  $devTab->{"bz_rollo"}->{valueFns}->{"schatten"}="{if...}";
  $devTab->{"bz_rollo"}->{SetFn}="";
# Badezimmer (Ost)
  $devTab->{"bz_rollo"}->{valueFns}->{"nacht"}="0";
  $devTab->{"bz_rollo"}->{valueFns}->{"schatten"}="{if...}";
# Kinderzimmer A (Paula) (West)
  $devTab->{"ka_rollo"}->{SetFn}="";
# Kinderzimmer B (Hanna) (Ost)
  $devTab->{"kb_rollo"}->{SetFn}="";
# Kueche (Ost)
  $devTab->{"ku_rollo"}->{SetFn}="";
# Schlafzimmer (West)
  $devTab->{"sz_rollo"}->{SetFn}="";
# Wohnzimmer (West)
  $devTab->{"wz_rollo_l"}->{SetFn}="";
  $devTab->{"wz_rollo_r"}->{SetFn}=""; 

# TODO


#technisches
sub myCtrlProxies_Initialize($$);

# Sensoren
sub myCtrlProxies_getSensor($);
sub myCtrlProxies_getSensors(;$$$$); # <SenName/undef> [<type>][<DevName>][<location>]

# 
sub myCtrlProxies_getDevices(;$$$);# <DevName/undef>(undef => alles) [<Type>][<room>]

# Rooms
sub myCtrlProxies_getRooms();
sub myCtrlProxies_getActions(;$); # <DevName>

# Action
sub myCtrlProxies_doAllActions();
sub myCtrlProxies_doAction($$);
sub myCtrlProxies_DeviceSetFn($@);

#------------------------------------------------------------------------------

sub
myCtrlProxies_Initialize($$)
{
  my ($hash) = @_;
}

#------------------------------------------------------------------------------
# returns Sensor-Record by name
# Parameter: name 
# record:
#  X->{name}->{alias}     ="Text zur Anzeige etc.";
#  X->{name}->{fhem_name} ="Name in FHEM";
#  X->{name}->{type}      ="Typ f�r Gruppierung und Suche";
#  X->{name}->{location}  ="Zugeh�rigkeit zu einem Raum ($rooms)";
#  X->{name}->{readings}->{<readings_name>} ->{reading}  ="temperature";
#  X->{name}->{readings}->{<readings_name>} ->{unit}     ="�C";
#  ...
sub 
myCtrlProxies_getSensor($)
{
	my ($name) = @_;
	return $sensors->{$name};
}

# sucht gew�nschtes reading zu dem angegebenen device, folgt den in {composite} definierten (Unter)-Devices.
sub
myCtrlProxies_getSensorReadingCompositeRecord_intern($$)
{
	my ($device_record,$reading) = @_;
	my $readings_record = $device_record->{readings};
	my $single_reading_record = $readings_record->{$reading};
	return $single_reading_record unless !defined($single_reading_record);
	
	# composites verarbeiten
	# e.g.  $sensors->{wz_wandthermostat}->{composite} =("wz_wandthermostat_climate"); 
	my $composites = $device_record->{composite};
	foreach my $composite_name ($composites) {
		my $new_device_record = myCtrlProxies_getSensor($composite_name);
		my $new_single_reading_record = myCtrlProxies_getSensorReadingCompositeRecord_intern($new_device_record,$reading);
		if(defined($new_single_reading_record )) {
			return $new_single_reading_record ;
		}
	}
	
	return undef;
}

# parameters: name, reading name
# record:
#  X->{reading} = "<fhem_device_reading_name>";
#  X->{unit} = "";
sub 
myCtrlProxies_getSensorReadingRecord($$)
{
	my ($name, $reading) = @_;
	my $record = myCtrlProxies_getSensor($name);
	if(defined($record)) {
    return myCtrlProxies_getSensorReadingCompositeRecord_intern($record,$reading);
  }
	return undef;
}

# parameters: name, reading name
# returns current readings value
sub 
myCtrlProxies_getSensorReadingValue($$)
{
	my ($name, $reading) = @_;
	my $record = myCtrlProxies_getSensor($name);
	if (defined($record)) {
    my $single_reading_record = myCtrlProxies_getSensorReadingCompositeRecord_intern($record,$reading);
    if(defined($single_reading_record)) {    
      my $fhem_name = $record->{fhem_name};
      my $reading_fhem_name = $single_reading_record->{reading};
      return ReadingsVal($fhem_name,$reading_fhem_name,undef); 
    }
  }
	return undef;
}

# parameters: name, reading name
# returns readings unit
sub 
myCtrlProxies_getSensorReadingUnit($$)
{
	my ($name, $reading) = @_;
	my $record = myCtrlProxies_getSensorReadingRecord($name,$reading);
	if (defined($record)) {
	  return $record->{unit};
	}
	return undef;
}


#------------------------------------------------------------------------------

#- Steuerung fuer manuelle Aufrufe (AT) ---------------------------------------

###############################################################################
# Alle Aktionen aus der Tabelle ausfuehren.
# (f�r alle Devices, solange nicht anders definiert) 
###############################################################################
sub
myCtrlProxies_doAllActions() {
	Main:Log 3, "PROXY_CTRL:--------> do all ";
	foreach my $act (keys %{$actTab}) {
		my $cTab = $actTab->{$act};
		myCtrlProxies_doAction($cTab, $act);
	}
}

###############################################################################
# Eine bestimmte Aktion ausfuehren.
# (f�r alle Devices, solange nicht anders definiert) 
###############################################################################
sub
myCtrlProxies_doAction($$) {
	my ($cTab, $actName) = @_;
	
	Log 3, "PROXY_CTRL:--------> do ".$actName;
	
	my $disabled = $cTab->{disabled}; # undef => enabled
	Log 3, "PROXY_CTRL:--------> act ".$actName." disabled:".$disabled;
	if(defined($disabled) && $disabled eq '1') { return }; # wenn disabled => raus
	
	my $checkFn = $cTab->{checkFn}; # undef => ausf�hren
	Log 3, "PROXY_CTRL:--------> act ".$actName." checkFn:".$checkFn;
	if(defined($checkFn)) {
		my $valueFn = eval $checkFn;
		if(!defined($valueFn)) { return }; # wenn undef => raus
    if( !$valueFn ) { return }; # wenn false => raus
	}
	
	my @devList = $cTab->{deviceList}; # undef => f�r alle ausf�hren
	Log 3, "PROXY_CTRL:--------> act ".$actName." deviceList: ".@devList;
	if(@devList) {
	 	foreach my $dev (@devList) {
	 		Log 3, "PROXY_CTRL:--------> act ".$actName." device:".$dev;
		  myCtrlProxies_DeviceSetFn($dev, $actName);
	  }
	} else {
	  foreach my $dev (keys %{$devTab}) {     
	  	Log 3, "PROXY_CTRL:--------> act ".$actName." device:".$dev;
  	  if($dev ne 'DEFAULT') {
  	  	myCtrlProxies_DeviceSetFn($dev, $actName, "www"); #?
  	  }
    }
	}
}                                              

#- Steuerung aus ReadingProxy -------------------------------------------------

###############################################################################
# Eine bestimmte (Set-)Aktion f�r ein bestimmtes Ger�t ausfuehren.
# (Commando kann gefiltert und ver�ndert werden, 
# d.h. ggf. nicht oder anders ausgef�hrt)
# Beispiel: Befehl 'schatten' f�r Rolladen: es wird gepr�ft (f�r jedes Rollo
# einzeln) ob die Ausf�hrung notwendig ist (richtige Tageszeit?, Temperatur? 
# starke Sonneneinstrahlung?, aus richtiger Richtung?)
# und auch wie stark (wie weit soll Rollo heruntergefahren werden).
###############################################################################
sub
myCtrlProxies_DeviceSetFn($@) {
	my ($DEVICE,@a) = @_;
	my $CMD = $a[0];
  my $ARGS = join(" ", @a[1..$#a]);
  
  #TODO
  Log 3, "PROXY_CTRL:--------> set ".$DEVICE." - ".$CMD." - ".$ARGS;
  my $cmdFn = $devTab->{$DEVICE}->{valueFns}->{$CMD}; #TODO
  if(defined($cmdFn)) {
  	# TODO
  } else {
    return;
  }
}

# Zur Verwendung in ReadingProxy. Pr�ft (transparent) ob und wie ein Befehl ausgef�hrt werden soll.
# TODO
sub
myCtrlProxies_SetProxyFn($@) {
	my ($DEVICE,@a) = @_;
	my $CMD = $a[0];
  my $ARGS = join(" ", @a[1..$#a]);
  
  #TODO
  Log 3, "PROXY_CTRL:--------> set ".$DEVICE." - ".$CMD." - ".$ARGS;
  my $cmdFn = $devTab->{$DEVICE}->{valueFns}->{$CMD};
  if(defined($cmdFn)) {
  	# TODO
  } else {
    return ""; # pass through cmd to device
  }
}

1;
