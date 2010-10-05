# What #
 
Meteor is a stateless widget framework for Ruby on Rails released under the MIT License.
 
 
# Why
 
Meteor supports the construction of complex UI widgets that:

*   Can be reused in multiple applications;
*   Can be "parameterized" via metadata or "specifications";
*   Offer extension points to override default behavior;
*   Can be simply and easily distributed, installed, and rendered.

Meteor is a low overhead framework to DRY out your partials.  Some existing widgets include:
A menu system that can be embedded anywhere (but most usefully in application layout templates);
Hierarchical collapsible form builders driven by model relationships and attributes;
A remote content proxy for white-labeling application functionality with third-party styling, headers, footers, etc.

# How

The Meteor framework installs as a Rails plugin.  Widgets also install as plugins.  Meteor contains generators that allow anyone to construct their own widget plugins.  Once a widget is installed, it can be rendered via a one-liner.

Starting from scratch, you can be rendering an existing meteor widget in your application in two minutes.
 
Meteor uses core Ruby and Rails building blocks:  classes, ERB templates, and plugins.  A widget requires a minimum of two files:  a ruby "specification" class and a default partial.  The rest of the required infrastructure is unfurled via rails generators. 

Blog posts and documentation describing the above is available (see Where below).

# Where


*   [Github:](http://github.com/bretweinraub/meteor)
    http://github.com/bretweinraub/meteor
*   [Blog/Docs:](http://www.aura-software.com/entries/4-about-the-meteor-plugin)
    http://www.aura-software.com/entries/4-about-the-meteor-plugin
*   [Widget catalog:](http://meteor-catalog.aura-software.com)
    http://meteor-catalog.aura-software.com
*   [Discussion group:](http://groups.google.com/group/meteor-plugin)
    http://groups.google.com/group/meteor-plugin
*   [Direct contact](http://www.aura-software.com/contact) http://www.aura-software.com/contact

# Who

[Aura Software LLC](http://www.aura-software.com)
