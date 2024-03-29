ExtScaffold
===========

Scaffolds an entire resource, from model and migration to controller and
views, along with a full test suite, just like the standard Rails scaffold
generator. The ext_scaffold generator uses the Ext Javascript framwork to 
build the GUI elements (forms and tables).

Pass the name of the model, either CamelCased or under_scored, as the first
argument, and an optional list of attribute pairs.

Attribute pairs are column_name:sql_type arguments specifying the
model's attributes. Timestamps are added by default, so you don't have to
specify them by hand as 'created_at:datetime updated_at:datetime'.

For example, `ext_scaffold post title:string body:text published:boolean`
gives you a model with those three attributes, a controller that handles
the create/show/update/destroy, Ext forms to create and edit your posts, and
an Ext Grid index that lists them all, as well as a map.resources :posts
declaration in config/routes.rb.


Prerequisites
=============

You need to download the Ext Javascript framework from

`http://extjs.com/download`,

and unzip it into `#{RAILS_ROOT}/public/ext`. Ext_scaffold was tested
against version 2.2 of the ExtJS framework.


Installation
============

`script/plugin install git://github.com/martinrehfeld/ext_scaffold.git`


Example
=======

`./script/generate ext_scaffold post` # no attributes, view will be anemic

`./script/generate ext_scaffold post title:string body:text published:boolean`

`./script/generate ext_scaffold purchase order_id:integer amount:decimal`


Copyright (c) 2008 martin.rehfeld@glnetworks.de, released under the MIT license