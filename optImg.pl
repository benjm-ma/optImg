##########################################################
# Reads one or more images, resizes and 
# resamples them to the desired ppi using the PerlMagick
# API.
#
# Options: 
#	-d : The new dpi for the image(s) to be resampled to.
#			This value is taken in by default as the last
#			argument so this option is optional.
#
# Version Notes:
#  - Only JPEG, PNG, and TIFF are the supported image formats
#		processed by this script. All others will be ommitted 
#		from processing.
##########################################################

use Image::Magick;
use Path::Class;
use File::Basename;
use strict;

my( $imObj, @images, $imageName, $dir, $destDir );

$imObj= Image::Magick-> new;

# TODO: Parse Options

switch( scalar(@ARGV) ){
	# Only the desired dpi value was passed
	case 1{

		if( @ARGV[0]~= qr/.*[a-zA-Z].*/ ){
			&inform( 'err', 
				@ARGV[0]. " is not a valid dpi
				value");
			die;
		}	

		&inform( 'warn',
		 "Converting images within current
		 directory. Is this okay? [y|n]: ");
		my $userIn= <STDIN>;
		if( $userIn!~ qr/^[Y|y]/){
			&inform( 'err', "No images or 
				directory provided");
			die;
		}

		$dir= dir();
	}
	# Source dir or single image provided
	case 2{

		if( -d @ARGV[0] ){
			my $dir= dir(@ARGV[0]);
		}else if( defined $imObj->Ping( @ARGV[0] ) ){ # Is it an image?
			$imageName= @ARGV[0];
		}else{
			&inform( 'err',
				@ARGV[0]. " is not a valid image or 
					directory location");
			die;
		}
	}
}

# Go through all files only adding images to queue
while( my $file= $dir->next() ){
	if( defined $magickObj->Ping( $file->basename ) ){
		push @images, ($file->basename);
	}
}

&inform( 'attn', 
	scalar(@images) ." will be 
	resampled and resized.");

# TODO: Load images.

# TODO: Store total size of all images to be processed.

# TODO: Create a directory to store all resampled images 
#	into.

######################################
# inform - Sends warnings and error 
#	messages to the console. When 
#	'u' is used, a usage message is 
#	printed, and any specified 
#	message is appended to that.
#
# param 0 - Message type [w|e|u|a]
# 	(warning, error, usage, attention,
#	respectively).
# param 1 - Message
######################################
sub inform{
	my($stream, $message);
	switch(@_[0]){
		case 'warn'{ 
			$message= "WARNING: ";
			$stream= STDOUT;
		}
		case 'err'{
			$message= "ERROR: ";
			$stream= STDERR;
		}
		case 'usg'{
			$message= \&usage;
			$stream= STDOUT;
		}
		case 'attn'
		else {
			$message= "";
			$stream= STDOUT;
		}
	}
	print $message. @_[1] ."\n" >> $stream;
	return;
}

######################################
# usage - simply returns a usage
#	message to be printed tot the 
#	console.
#
#	return - Usage message.
######################################
sub usage{
	# TODO: Write usage message
	return "";
}
