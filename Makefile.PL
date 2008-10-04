use inc::Module::Install;

name 'Text-EmacsColor';
all_from 'lib/Text/EmacsColor.pm';

build_requires 'Test::More';
build_requires 'ok';

WriteAll();
