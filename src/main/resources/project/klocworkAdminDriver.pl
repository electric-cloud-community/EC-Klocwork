    # -------------------------------------------------------------------------
	# Package
	#    klocworkAdminDriver.pl.pl
	#
	# Dependencies
	#    None
	#
	# Purpose
	#    Template for Single Command-line Plug-ins
	#
	# Template Version
	#    1.0
	#
	# Date
	#    01/02/2012
	#
	# Engineer
	#    Carlos Rojas
	#
	# Copyright (c) 2010 Electric Cloud, Inc.
	# All rights reserved
	# -------------------------------------------------------------------------

    # -------------------------------------------------------------------------
	# Includes
	# -------------------------------------------------------------------------
    use ElectricCommander;
    use warnings;
    use strict; 
    $|=1;

    # -------------------------------------------------------------------------
	# Variables
	# -------------------------------------------------------------------------
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);
    $::gKwroot              = ($ec->getProperty( "klocroot" ))->findvalue('//value')->string_value;
    $::gTablesDir           = ($ec->getProperty( "tablesDir" ))->findvalue('//value')->string_value;
    $::gVerbose             = ($ec->getProperty( "verbose" ))->findvalue('//value')->string_value;
    $::gAction              = ($ec->getProperty( "action" ))->findvalue('//value')->string_value;
    $::gLanguage            = ($ec->getProperty( "language" ))->findvalue('//value')->string_value;
    $::gKlocworkProjectName = ($ec->getProperty( "klocworkProjectName" ))->findvalue('//value')->string_value;
    $::gWorkingDir          = ($ec->getProperty( "workingDir" ))->findvalue('//value')->string_value;


    #more global variables to be added here
    
    # -------------------------------------------------------------------------
	# Main functions
	# -------------------------------------------------------------------------
    
    ########################################################################
    # main - contains the whole process to be done by the plugin, it builds the
    #        command line, sets the properties and the working directory
    #
    # Arguments:
    #   -none
    #
    # Returns:
    #   -nothing
    #
    ########################################################################
    sub main() {
        
        # create args array
        my @args = ();
        
        #properties' map
        my %props;
        
        my $executable = "";
        
        if($::gKwroot && $::gKwroot ne ""){
            $executable = $::gKwroot;
        }
        
        $executable .= "kwadmin";
        
        push(@args, $executable);

        if($::gVerbose && $::gVerbose ne "")
        {
            push(@args, "--verbose");
        }
        
        if($::gAction && $::gAction ne "")
        {
            push(@args, $::gAction );
        }
        
        if($::gKlocworkProjectName && $::gKlocworkProjectName ne "")
        {
            push(@args, $::gKlocworkProjectName );
        }
        
        if($::gLanguage && $::gLanguage ne "" && $::gAction && $::gAction eq "create-project"){
            push(@args, "--language $::gLanguage");
        }
        
        if($::gTablesDir && $::gTablesDir ne "" && $::gAction && $::gAction eq "load"){
            push(@args, $::gTablesDir );
        }
        
        #generate the command to execute in console
        $props{"kwadminCommandLine"} = &createKlocworkCommandLine(\@args);
        
        #set the working directory
        $props{'workingdir'} = $::gWorkingDir;
        
        &setProperties(\%props);
        
    }
    
    ########################################################################
    # createCommandLine - builds up the command line that will be executed 
    #                     by the plugin
    #
    # Arguments:
    #   -arr: array containing the command name in the first position and the
    #         arguments in the following positions
    #
    # Returns:
    #   -a string with the command line
    #
    ########################################################################
    sub createKlocworkCommandLine($) {
        my ($arr) = @_;
        return join(" ", @$arr);
    }

    ########################################################################
    # setProperties - set a group of properties into the Electric Commander
    #
    # Arguments:
    #   -propHash: hash containing the ID and the value of the properties 
    #              to be written into the Electric Commander
    #
    # Returns:
    #   -nothing
    #
    ########################################################################
    sub setProperties($) {

        my ($propHash) = @_;

        # get an EC object
        my $ec = new ElectricCommander();
        $ec->abortOnError(0);
        
        my $pluginKey = 'EC-Klocwork';
        my $xpath = $ec->getPlugin($pluginKey);
        my $pluginName = $xpath->findvalue('//pluginVersion')->value;
        print "Using plugin $pluginKey version $pluginName\n";
        
        foreach my $key (keys % $propHash) {
            my $val = $propHash->{$key};
            $ec->setProperty("/myCall/$key", $val);
        }
    }

    main();

