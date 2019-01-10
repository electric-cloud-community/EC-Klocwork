my %runKwinject = (
    label       => "Klocwork - Run kwinject",
    procedure   => "runKwinject",
    description => "Run kwinject tasks",
    category    => "Code Analysis"
);

my %runKwbuildproject = (
    label       => "Klocwork - Run kwbuild",
    procedure   => "runKwbuildproject",
    description => "Run kwbuild tasks",
    category    => "Code Analysis"
);

my %AdminProject = (
    label       => "Klocwork - Run kwbuild",
    procedure   => "AdminProject",
    description => "Run kwadmin tasks",
    category    => "Code Analysis"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Klocwork - Run Klocwork kwinject");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Klocwork - Run Klocwork kwbuild");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Klocwork - Run Klocwork kwadmin");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Klocwork - Kwinject");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Klocwork - Kwbuildproject");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Klocwork - AdminProject");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Klocwork - Run kwinject");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Klocwork - Run kwbuild");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Klocwork - Run kwbuild");

@::createStepPickerSteps = (\%runKwinject, \%runKwbuildproject, \%AdminProject);
