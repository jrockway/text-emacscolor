use inc::Module::Install;

name 'Text-EmacsColor';
all_from 'lib/Text/EmacsColor.pm';

requires 'File::ShareDir';
requires 'File::Temp';
requires 'Mouse';
requires 'Path::Class';
requires 'namespace::clean';
build_requires 'Test::More';
build_requires 'ok';

install_share 'share';

requires_external_bin 'emacs';

WriteAll();
