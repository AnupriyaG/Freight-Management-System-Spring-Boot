/*!
=====================================

OneMenu by SONHLAB.com - version 2.0 
website: http://sonhlab.com
Documentation: http://docs.sonhlab.com/onemenu-responsive-metro-ui-menu/

build - 0044
=====================================
*/

!function(i){var t=function(t,n){function o(t){if("hide"==x.closemenu?$ctrlitemsWidth=h-50:$ctrlitemsWidth=h-100,f=i("#"+t).find(".om-ctrlitems").find(".om-ctrlitem").length,c=Math.floor($ctrlitemsWidth/48),i("#"+t).find(".om-ctrlitems").find(".om-centerblock").find(".om-ctrlitem").css({display:"none"}),$=0,c>=f)i(".om-nav").find(".om-movenext").css({display:"none"}),i("#"+t).find(".om-ctrlitems").find(".om-centerblock").find(".om-ctrlitem").css({display:"inline-block"}),"hide"==x.closemenu?$ctrlitemsWidth=h:$ctrlitemsWidth=h-50;else{i(".om-nav").find(".om-movenext").css({display:"block"});for(var n=0;c>n;n++)i("#"+t).find(".om-ctrlitems").find(".om-centerblock").find(".om-ctrlitem").eq(n).css({display:"inline-block"});l=n,"hide"==x.closemenu?$ctrlitemsWidth=h-50:$ctrlitemsWidth=h-100}i("#"+t).find(".om-ctrlitems").css({width:$ctrlitemsWidth+"px"})}function e(t,n){if(z.masonry("destroy"),"overlay"==x.openstyle?i("#"+t).css({position:"absolute"}):i("#"+t).css({position:"relative"}),v=Math.floor((h-10)/100),w=100*v,g=(h-w)/2,i("#"+t).find(".om-itemholder").css({width:w+"px",padding:g+"px"}),o(t),"center"==x.ctrlalign?i("#"+t).find(".om-ctrlitems").css({"text-align":"center",margin:"auto "+k+"px"}):"left"==x.ctrlalign?i("#"+t).find(".om-ctrlitems").css({"text-align":"left","margin-left":k+"px"}):i("#"+t).find(".om-ctrlitems").css({"text-align":"right","margin-left":k+"px"}),"show"==n){i("#"+t).find(".om-ctrlitems").find(".om-ctrlitem").eq(0).addClass("om-activectrlitem");var e=i("#"+t).find(".om-ctrlitems").find(".om-ctrlitem").eq(0).attr("data-groupid");i("#"+t).find(".om-itemlist").find('div[data-group="'+e+'"]').toggleClass("om-item om-showitem"),i("#"+t).find(".om-itemlist").find(".om-showitem").css({display:"block"}),"fade"==C?i("#"+t).find(".om-itemholder").fadeIn(400,function(){u=i("#"+t).parent().width(),h!=u?m(u):(i("#"+t).find(".om-itemlist").find(".om-showitem").css({display:"block"}),z.masonry(D))}):"slide"==C?i("#"+t).find(".om-itemholder").slideDown(400,function(){u=i("#"+t).parent().width(),h!=u?m(u):(i("#"+t).find(".om-itemlist").find(".om-showitem").css({display:"block"}),z.masonry(D))}):(i("#"+t).find(".om-itemholder").css({display:"block"}),u=i("#"+t).parent().width(),h!=u?m(u):(i("#"+t).find(".om-itemlist").find(".om-showitem").css({display:"block"}),z.masonry(D)))}else i(".om-itemholder").css({display:"none"}),z.masonry(D)}function m(t){h=t,v=Math.floor((h-10)/100),w=100*v,g=(h-w)/2,i("#"+p).find(".om-itemholder").css({width:w+"px",padding:g+"px"}),i("#"+p).find(".om-itemlist").find(".om-showitem").css({display:"block",opacity:0}),z.masonry(D),o(p),i("#"+p).find(".om-itemlist").find(".om-showitem").css({display:"block",opacity:1})}function s(t){for($+=1,a=c+c*$,i("#"+t).find(".om-ctrlitems").find(".om-centerblock").find(".om-ctrlitem").css({display:"none"}),l>=f&&($=0,l=0,a=c),l;a>l;l++)i("#"+t).find(".om-ctrlitems").find(".om-centerblock").find(".om-ctrlitem").eq(l).css({display:"block"});return!1}function d(i,t){var n,t=t||200;return function(){var o=this,e=arguments;clearTimeout(n),n=setTimeout(function(){i.apply(o,Array.prototype.slice.call(e))},t)}}var l,a,c,f,r,h,u,p,w,v,y,g,b,k,x=i.extend({},i.fn.onemenu.defaults,n),C=x.animEffect,W=x.hidezone,$=0,I=0,q=i(window).width();k="hide"==x.closemenu?0:50;var D={itemSelector:".om-showitem",isFitWidth:!0,columnWidth:100},z=i(t).find(".om-nav").find(".om-itemlist").masonry(D);x.autoshow&&(p=x.autoshow,i(t).find("#"+p).length>0?0==I&&(I=1,h=i("#"+p).parent().width(),"fade"==C?i("#"+p).fadeIn(400,function(){}):i("#"+p).css({display:"block"}),y=x.submenu,e(p,y)):alert("Your menu ID is not found. Please check your autoshow value!")),i(t).find(".onemenu").on("click",function(){0==I&&(p=i(this).attr("data-navid"),h=i("#"+p).parent().width(),y=i(this).attr("data-submenu")?i(this).attr("data-submenu"):x.submenu,I=1,""!=W&&i(W).addClass("none"),"fade"==C?i("#"+p).fadeIn(400,function(){e(p,y)}):"slide"==C?i("#"+p).slideDown(400,function(){e(p,y)}):(i("#"+p).css({display:"block"}),e(p,y)))}),i(".om-nav").find(".om-ctrlbar").find(".om-movenext").on("click",function(){s(p)}),i(t).find(".om-nav").find(".om-ctrlitem").on("click",function(){if(i(this).hasClass("om-activectrlitem"))r=i(".om-activectrlitem").attr("data-groupid"),i(t).find(".om-nav").find(".om-ctrlitem").removeClass("om-activectrlitem"),r&&(i("#"+p).find(".om-itemlist").find(".om-showitem").css({display:"none"}),i("#"+p).find(".om-itemlist").find('div[data-group="'+r+'"]').toggleClass("om-item om-showitem")),i("#"+p).find(".om-itemholder").slideUp(400,"swing",function(){y="hide"});else{r=i(".om-activectrlitem").attr("data-groupid"),i(t).find(".om-nav").find(".om-ctrlitem").removeClass("om-activectrlitem"),z.masonry("destroy"),r&&(i("#"+p).find(".om-itemlist").find(".om-showitem").css({display:"none"}),i("#"+p).find(".om-itemlist").find('div[data-group="'+r+'"]').toggleClass("om-item om-showitem"));var n=i(this).attr("data-groupid");i("#"+p).find(".om-itemlist").find('div[data-group="'+n+'"]').toggleClass("om-item om-showitem"),i(this).addClass("om-activectrlitem"),h=i("#"+p).parent().width(),b=i("#"+p).find(".om-itemlist").find(".om-showitem").length,i("#"+p).find(".om-itemlist").find(".om-showitem").fadeIn(400,function(){u=i("#"+p).parent().width(),h!=u?0==--b&&m(u):(i("#"+p).find(".om-itemlist").find(".om-showitem").css({display:"block"}),z.masonry(D))}),i("#"+p).find(".om-itemholder").slideDown(400,"swing",function(){}),z.masonry(D)}}),i(t).find(".om-nav").find(".om-closenav").on("click",function(){I=0,""!=W&&i(W).removeClass("none"),i(t).find(".om-nav").find(".om-ctrlitem").removeClass("om-activectrlitem"),i(t).find(".om-nav").find(".om-itemlist").find(".om-showitem").css({display:"none"}),i(t).find(".om-nav").find(".om-itemlist").find(".om-showitem").toggleClass("om-item om-showitem"),"fade"==C?i("#"+p).fadeOut(400,function(){}):"slide"==C?i("#"+p).slideUp(400,function(){}):i("#"+p).css({display:"none"})}),i(window).resize(d(function(){if(1==I){var t=i(window).width();q!=t&&(u=i("#"+p).parent().width(),h!=u&&m(u),q=t)}}))};i.fn.onemenu=function(n){return this.each(function(o,e){if(i(this).data("onemenu"))return i(this).data("onemenu");var m=new t(this,n);i(this).data("onemenu",m)})},i.fn.onemenu.defaults={openstyle:"overlay",ctrlalign:"center",submenu:"show",closemenu:"show",hidezone:"",animEffect:"none"}}(jQuery);