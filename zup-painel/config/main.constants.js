"use strict";

 angular.module('config', [])

.constant('ENV', {name:'production',apiEndpoint:'http://api:8888',mapLat:'-23.6606',mapLng:'-47.2241',mapZoom:'11',flowsEnabled:'true',pageTitle:'PAGE_TITLE',zendeskUrl:'https://zeladoriaurbana.zendesk.com/hc/pt-br',ckeditorPath:'assets/scripts/ckeditor/ckeditor.js',version:'1.2.0'})

;