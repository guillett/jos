$(document).ready(function() {
    function formatRepo (repo) {
        if (repo.loading) return repo.text;

        var markup = "<div class='select2-result-repository clearfix'>" +
            "<div class='select2-result-repository__avatar'><img src='" + repo.owner.avatar_url + "' /></div>" +
            "<div class='select2-result-repository__meta'>" +
            "<div class='select2-result-repository__title'>" + repo.full_name + "</div>";

        if (repo.description) {
            markup += "<div class='select2-result-repository__description'>" + repo.description + "</div>";
        }

        markup += "<div class='select2-result-repository__statistics'>" +
            "<div class='select2-result-repository__forks'><i class='fa fa-flash'></i> " + repo.forks_count + " Forks</div>" +
            "<div class='select2-result-repository__stargazers'><i class='fa fa-star'></i> " + repo.stargazers_count + " Stars</div>" +
            "<div class='select2-result-repository__watchers'><i class='fa fa-eye'></i> " + repo.watchers_count + " Watchers</div>" +
            "</div>" +
            "</div></div>";

        return markup;
    }

    function formatRepoSelection (repo) {
        return repo.full_name || repo.text;
    }

    var algolia = new AlgoliaSearch('P1QQB6BNNQ', 'cadea80b43b8c9a5640c44b240de7793');
    var index = algolia.initIndex('JoKeywords');

    $("#toto").select2({
        ajax: {
            // Custom transport to call Algolia's API
            transport: function(params, success, failure) {
                var q = params.data.query;
                delete params.data.query;
                index.search(q, function(algolia_success, content) {
                    if (algolia_success) {
                        console.log(content)
                        success();
                    }
                }, params.data);
            },
            // build Algolia's query parameters
            data: function(params) {
                return { query: params.term, hitsPerPage: 10, page: 1 };
            },
            // return Algolia's results
            results: function(data, page) {
                console.log("HELLOOOO")
                return { results: data.hits }
            }
        }
    });
});