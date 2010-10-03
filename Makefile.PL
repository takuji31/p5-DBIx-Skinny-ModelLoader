use inc::Module::Install;
name 'DBIx-Skinny-ModelLoader';
all_from 'lib/DBIx/Skinny/ModelLoader.pm';
readme_pod_from 'lib/DBIx/Skinny/ModelLoader.pm';
githubmeta;

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
