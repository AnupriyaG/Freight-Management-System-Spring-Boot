window.addEventListener('load', function () {
    quickNav=new Vue({
        el: '#menu',
        vuetify: new Vuetify(),
        data: () => ({
            items: [
              { title: 'Click Me' },
              { title: 'Click Me' },
              { title: 'Click Me' },
              { title: 'Click Me 2' },
            ],
        }),
    })
})
