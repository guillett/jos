$(document).ready(function() {

    var algolia = new AlgoliaSearch('P1QQB6BNNQ', 'cadea80b43b8c9a5640c44b240de7793');
    var index = algolia.initIndex('JoKeywords');

    $.fn.select2.amd.require(['select2/selection/search'], function (Search) {
        var oldRemoveChoice = Search.prototype.searchRemoveChoice;

        Search.prototype.searchRemoveChoice = function () {
            oldRemoveChoice.apply(this, arguments);
            this.$search.val('');
        };


        $("#keywords").select2({
            ajax: {
                // Custom transport to call Algolia's API
                transport: function(params, success, failure) {
                    var q = params.data.query;
                    delete params.data.query;
                    index.search(q, function(algolia_success, content) {
                        if (algolia_success) {
                            success(content);
                        }
                    }, params.data);
                },
                // build Algolia's query parameters
                data: function(params) {
                    return { query: params.term, hitsPerPage: 10, page: 0 };
                },
                // return Algolia's results
                results: function(data, page) {
                    return { results: data.hits }
                },
                processResults: function (data) {
                    console.log(data.hits)
                    var well_formed = $.map(data.hits, function(el,i ) {return { id: el.label, text: el.label } });
                    return {
                        results: well_formed
                    };
                }

            },
            minimumInputLength: 2

        });

    });

});