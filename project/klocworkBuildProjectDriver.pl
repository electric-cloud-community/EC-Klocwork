    # -------------------------------------------------------------------------
	# Package
	#    klocworkBuildProjectDriver.pl
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
    $::gForce= ($ec->getProperty( "force" ))->findvalue('//value')->string_value;
    $::gLicenseHost= ($ec->getProperty( "licenseHost" ))->findvalue('//value')->string_value;
    $::gLicensePort= ($ec->getProperty( "licensePort" ))->findvalue('//value')->string_value;
    $::gTablesDir= ($ec->getProperty( "tablesDir" ))->findvalue('//value')->string_value;
    $::gVerbose= ($ec->getProperty( "verbose" ))->findvalue('//value')->string_value;
    $::gAdditionalCommands= ($ec->getProperty( "kwbuildprojectCommands" ))->findvalue('//value')->string_value;
    $::gWorkingDir= ($ec->getProperty( "workingDir" ))->findvalue('//value')->string_value;
    
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
        
        $executable .= "kwbuildproject"; 
        
        push(@args, $executable);
        
        if($::gVerbose && $::gVerbose ne "")
        {
            push(@args, "-v");
        }
        
        if($::gForce && $::gForce ne "") {
            push(@args, "-f");
        }
        
        if($::gLicenseHost && $::gLicenseHost ne "") {
            push(@args, "-H=" . $::gLicenseHost);
        }
        
        if($::gLicensePort && $::gLicensePort ne "") {
            push(@args, "-P=" . $::gLicensePort);
        }  
        
        # if gAdditionalCommands contains text: add the additional 
        # commands that the user specified
        if($::gAdditionalCommands  && $::gAdditionalCommands  ne "") {
            foreach my $kwinjectCommand (split(' +', $::gAdditionalCommands)) {
                push(@args, "$kwinjectCommand");
            }
        } 
        
        if($::gTablesDir && $::gTablesDir ne "") {
            push(@args, "--tables-directory " . $::gTablesDir );
        }  
        
        #generate the command to execute in console
        $props{"kwbuildprojectCommandLine"} = createKlocworkCommandLine(\@args);
        #set the working directory
        $props{'workingdir'} = $::gWorkingDir;
        
        setProperties(\%props);

    }

    ########################################################################
    # createKlocworkCommandLine - builds up the command line that will be executed 
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
    sub createKlocworkCommandLine {
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
    sub setProperties {

        my ($propHash) = @_;

        # get an EC object
        my $ec = new ElectricCommander();
        $ec->abortOnError(0);

        foreach my $key (keys % $propHash) {
            my $val = $propHash->{$key};
            $ec->setProperty("/myCall/$key", $val);
        }
    }

    main();

