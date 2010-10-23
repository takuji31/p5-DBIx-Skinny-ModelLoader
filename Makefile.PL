use inc::Module::Install;
name 'DBIx-Skinny-ModelLoader';
all_from 'lib/DBIx/Skinny/ModelLoader.pm';
readme_pod_from 'lib/DBIx/Skinny/ModelLoader.pm';
githubmeta;

# requires '';
requires 'UNIVERSAL::require';
requires 'String::CamelCase';
requires 'DBIx::Skinny';
requires 'Class::Accessor::Fast';
requires 'Class::Data::Inheritable';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
auto_include;
auto_install;
WriteAll;
