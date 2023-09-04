package Search;

use LWP::UserAgent;
use URI::Escape;
use JSON;
use IPC::Run3;

BEGIN {
}

sub new {
    run3 ['/opt/homebrew/bin/gpg', '--decrypt', '--batch', 'secure-config.gpg'], undef, \my $output, undef, undef;

    my $api_key = decode_json($output)->{'google-programmable-search-engine-api-key'};
    my $cx = decode_json($output)->{'google-programmable-search-engine-cx'}; # not secret

    return bless {
        ua => LWP::UserAgent->new,
        api_key => decode_json($output)->{'google-programmable-search-engine-api-key'},
        cx => decode_json($output)->{'google-programmable-search-engine-cx'}, # not secret
    }, __PACKAGE__;
}

sub search {
    my ($self, $query) = @_;

    $query = uri_escape($query);

    my $url = "https://www.googleapis.com/customsearch/v1?key=$self->{api_key}&cx=$self->{cx}&q=$query";

    my $response = $self->{ua}->get($url);
    die "HTTP request failed: " . $response->status_line unless $response->is_success;

    my $content = decode_json($response->decoded_content);

    return $content->{items};
}

1;

__DATA__
$content = {
          'kind' => 'customsearch#search',
          'url' => {
                     'template' => 'https://www.googleapis.com/customsearch/v1?q={searchTerms}&num={count?}&start={startIndex?}&lr={language?}&safe={safe?}&cx={cx?}&sort={sort?}&filter={filter?}&gl={gl?}&cr={cr?}&googlehost={googleHost?}&c2coff={disableCnTwTranslation?}&hq={hq?}&hl={hl?}&siteSearch={siteSearch?}&siteSearchFilter={siteSearchFilter?}&exactTerms={exactTerms?}&excludeTerms={excludeTerms?}&linkSite={linkSite?}&orTerms={orTerms?}&relatedSite={relatedSite?}&dateRestrict={dateRestrict?}&lowRange={lowRange?}&highRange={highRange?}&searchType={searchType}&fileType={fileType?}&rights={rights?}&imgSize={imgSize?}&imgType={imgType?}&imgColorType={imgColorType?}&imgDominantColor={imgDominantColor?}&alt=json',
                     'type' => 'application/json'
                   },
          'queries' => {
                         'nextPage' => [
                                         {
                                           'outputEncoding' => 'utf8',
                                           'title' => 'Google Custom Search - latest chatgpt news',
                                           'safe' => 'off',
                                           'searchTerms' => 'latest chatgpt news',
                                           'cx' => '050022ac8ca0642f0',
                                           'totalResults' => '253000000',
                                           'count' => 10,
                                           'inputEncoding' => 'utf8',
                                           'startIndex' => 11
                                         }
                                       ],
                         'request' => [
                                        {
                                          'searchTerms' => 'latest chatgpt news',
                                          'title' => 'Google Custom Search - latest chatgpt news',
                                          'safe' => 'off',
                                          'outputEncoding' => 'utf8',
                                          'cx' => '050022ac8ca0642f0',
                                          'totalResults' => '253000000',
                                          'startIndex' => 1,
                                          'inputEncoding' => 'utf8',
                                          'count' => 10
                                        }
                                      ]
                       },
          'searchInformation' => {
                                   'searchTime' => '0.331681',
                                   'totalResults' => '253000000',
                                   'formattedSearchTime' => '0.33',
                                   'formattedTotalResults' => '253,000,000'
                                 },
          'items' => [
                       {
                         'snippet' => "Mar 14, 2023 ... OpenAI has released GPT-4, the latest version of its hugely popular artificial intelligence chatbot ChatGPT. The new model can respond to\x{a0}...",
                         'htmlFormattedUrl' => 'https://www.bbc.com/<b>news</b>/technology-64959346',
                         'htmlSnippet' => 'Mar 14, 2023 <b>...</b> OpenAI has released GPT-4, the <b>latest</b> version of its hugely popular artificial intelligence chatbot <b>ChatGPT</b>. The new model can respond to&nbsp;...',
                         'displayLink' => 'www.bbc.com',
                         'cacheId' => 'xGMq5pFYXBQJ',
                         'htmlTitle' => 'OpenAI announces <b>ChatGPT</b> successor GPT-4 - BBC <b>News</b>',
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.bbc.com/news/technology-64959346',
                         'formattedUrl' => 'https://www.bbc.com/news/technology-64959346',
                         'pagemap' => {
                                        'cse_thumbnail' => [
                                                             {
                                                               'width' => '300',
                                                               'height' => '168',
                                                               'src' => 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSiuHe6rsEmyB-Dzh2B_XGpxMBUYzJ962ACzpYtGYjsDSRm3KsyRS6AlME'
                                                             }
                                                           ],
                                        'metatags' => [
                                                        {
                                                          'article:author' => 'https://www.facebook.com/bbcnews',
                                                          'theme-color' => '#FFFFFF',
                                                          'twitter:image:alt' => 'laptop screen with OpenAI GPT-4',
                                                          'msapplication-tileimage' => 'BBC News',
                                                          'og:type' => 'article',
                                                          'twitter:creator' => '@BBCWorld',
                                                          'og:image:alt' => 'laptop screen with OpenAI GPT-4',
                                                          'twitter:domain' => 'www.bbc.com',
                                                          'mobile-web-app-capable' => 'yes',
                                                          'og:image' => 'https://ichef.bbci.co.uk/news/1024/branded_news/7196/production/_128987092_gettyimages-1248236133.jpg',
                                                          'cleartype' => 'on',
                                                          'fb:admins' => '100004154058350',
                                                          'og:url' => 'https://www.bbc.com/news/technology-64959346',
                                                          'application-name' => 'BBC News',
                                                          'fb:pages' => '1143803202301544,317278538359186,1392506827668140,742734325867560,185246968166196,156060587793370,137920769558355,193435954068976,21263239760,156400551056385,929399697073756,154344434967,228735667216,80758950658,260212261199,294662213128,1086451581439054,283348121682053,295830058648,239931389545417,304314573046,310719525611571,647687225371774,1159932557403143,286567251709437,1731770190373618,125309456546,163571453661989,285361880228,512423982152360,238003846549831,176663550714,260967092113,118450564909230,100978706649892,15286229625,122103087870579,120655094632228,102814153147070,124715648647,153132638110668,150467675018739',
                                                          'og:title' => 'OpenAI announces ChatGPT successor GPT-4',
                                                          'viewport' => 'width=device-width, initial-scale=1',
                                                          'msapplication-tilecolor' => '#bb1919',
                                                          'og:description' => 'The fourth version of the AI chatbot can process both images and text.',
                                                          'og:locale' => 'en_GB',
                                                          'twitter:title' => 'OpenAI announces ChatGPT successor GPT-4',
                                                          'twitter:site' => '@BBCWorld',
                                                          'article:section' => 'Technology',
                                                          'fb:app_id' => '1609039196070050',
                                                          'twitter:image:src' => 'https://ichef.bbci.co.uk/news/1024/branded_news/7196/production/_128987092_gettyimages-1248236133.jpg',
                                                          'og:site_name' => 'BBC News',
                                                          'twitter:card' => 'summary_large_image',
                                                          'twitter:description' => 'The fourth version of the AI chatbot can process both images and text.'
                                                        }
                                                      ],
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://ichef.bbci.co.uk/news/1024/branded_news/7196/production/_128987092_gettyimages-1248236133.jpg'
                                                         }
                                                       ]
                                      },
                         'title' => 'OpenAI announces ChatGPT successor GPT-4 - BBC News'
                       },
                       {
                         'displayLink' => 'www.businessinsider.com',
                         'cacheId' => '-5SelaqKx5MJ',
                         'htmlTitle' => 'Everything You Need to Know About <b>ChatGPT</b>',
                         'snippet' => "Mar 1, 2023 ... Open AI's ChatGPT bot has spread everywhere in the last month, ... with even Insider reporters trying to simulate news stories or message\x{a0}...",
                         'htmlFormattedUrl' => 'https://www.businessinsider.com/everything-you-need-to-know-about-<b>chat- gpt</b>-2023-1',
                         'htmlSnippet' => 'Mar 1, 2023 <b>...</b> Open AI&#39;s <b>ChatGPT</b> bot has spread everywhere in the <b>last</b> month, ... with even Insider reporters trying to simulate <b>news</b> stories or message&nbsp;...',
                         'pagemap' => {
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://i.insider.com/639b8eeeb7e0f20018094910?width=1200&format=jpeg'
                                                         }
                                                       ],
                                        'cse_thumbnail' => [
                                                             {
                                                               'width' => '318',
                                                               'src' => 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQ0xqO_4lr1cAknp50oCFdgSitIW0qT1JM727ZqSIGinO2VutSRueK6qO9-',
                                                               'height' => '159'
                                                             }
                                                           ],
                                        'metatags' => [
                                                        {
                                                          'article:publisher' => 'businessinsider',
                                                          'title' => 'If you still aren\'t sure what ChatGPT is, this is your guide to the viral chatbot that everyone is talking about',
                                                          'datemodified' => '2023-04-04T08:51:12Z',
                                                          'sailthru.image.thumb' => 'https://i.insider.com/63c1c38133ffb700180fb581?width=160&format=jpeg',
                                                          'tbi-vertical' => 'Tech Insider',
                                                          'parsely-tags' => 'Open AI,artifial intelligence,chat bots,Innovation-Design',
                                                          'apple-mobile-web-app-title' => 'Business Insider',
                                                          'og:type' => 'article',
                                                          'theme-color' => '#ffffff',
                                                          'news_keywords' => 'Open AI, artifial intelligence, chat bots, Innovation-Design, Sindhu Sundar',
                                                          'sailthru.image.full' => 'https://i.insider.com/63c1c38133ffb700180fb581?width=1200&format=jpeg',
                                                          'sailthru.description' => 'Open AI\'s ChatGPT bot has spread everywhere in the last month, drawing investors and experiments with its possible role in people-facing services.',
                                                          'author' => 'Sindhu Sundar',
                                                          'linkedin:owner' => 'mid:1d5f7b',
                                                          'twitter:card' => 'summary_large_image',
                                                          'og:site_name' => 'Business Insider',
                                                          'apple-itunes-app' => 'app-id=554260576',
                                                          'twitter:site' => '@sai',
                                                          'sailthru.verticals' => 'sai, news',
                                                          'og:description' => 'Open AI\'s ChatGPT bot has spread everywhere in the last month, drawing investors and experiments with its possible role in people-facing services.',
                                                          'sailthru.title' => 'If you still aren\'t sure what ChatGPT is, this is your guide to the viral chatbot that everyone is talking about',
                                                          'msapplication-config' => '/public/assets/BI/US/favicons/browserconfig.xml?v=2021-08',
                                                          'sailthru.tags' => 'Open AI, artifial intelligence, chat bots, Innovation-Design, Sindhu Sundar',
                                                          'sailthru.date' => '2023-03-01',
                                                          'viewport' => 'width=device-width, initial-scale=1',
                                                          'fb:pages' => '20446254070',
                                                          'og:title' => 'If you still aren\'t sure what ChatGPT is, this is your guide to the viral chatbot that everyone is talking about',
                                                          'parsely-section' => 'sai',
                                                          'og:url' => 'https://www.businessinsider.com/everything-you-need-to-know-about-chat-gpt-2023-1',
                                                          'cxenseparse:recs:bii-imgalt' => 'An image of a phone with ChatGPT and OpenAI\'s logo visible.',
                                                          'datepublished' => '2023-03-01T13:43:06Z',
                                                          'ia:markup_url' => 'https://www.businessinsider.com/everything-you-need-to-know-about-chat-gpt-2023-1?fbia',
                                                          'sailthru.author' => 'Sindhu Sundar',
                                                          'og:image' => 'https://i.insider.com/639b8eeeb7e0f20018094910?width=1200&format=jpeg'
                                                        }
                                                      ]
                                      },
                         'title' => 'Everything You Need to Know About ChatGPT',
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.businessinsider.com/everything-you-need-to-know-about-chat-gpt-2023-1',
                         'formattedUrl' => 'https://www.businessinsider.com/everything-you-need-to-know-about-chat- gpt-2023-1'
                       },
                       {
                         'pagemap' => {
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://techcrunch.com/wp-content/uploads/2023/03/GettyImages-1462188043.jpg?resize=1200,798'
                                                         }
                                                       ],
                                        'metatags' => [
                                                        {
                                                          'oath:guce:inline-consent' => 'true',
                                                          'cxenseparse:url' => 'https://techcrunch.com/2023/05/12/chatgpt-everything-you-need-to-know-about-the-ai-powered-chatbot/',
                                                          'cxenseparse:posttype' => 'post',
                                                          'sailthru.image.thumb' => 'https://techcrunch.com/wp-content/uploads/2023/03/GettyImages-1462188043.jpg?w=50',
                                                          'cxenseparse:articleid' => '2517030',
                                                          'sailthru.description' => "ChatGPT, OpenAI\x{2019}s text-generating AI chatbot, has taken the world by storm. It\x{2019}s able to write essays, code and more given short text prompts, hyper-charging productivity. But it also has a more\x{2026}nefarious side. In any case, AI tools are not going away \x{2014} and indeed has expanded dramatically since its launch just a few months ago. [\x{2026}]",
                                                          'cxenseparse:description' => "ChatGPT, OpenAI\x{2019}s text-generating AI chatbot, has taken the world by storm. It\x{2019}s able to write essays, code and more given short text prompts, hyper-charging productivity. But it also has a more\x{2026}nefarious side. In any case, AI tools are not going away \x{2014} and indeed has expanded dramatically since its launch just a few months ago. [\x{2026}]",
                                                          'og:image:width' => '1200',
                                                          'twitter:data2' => '14 minutes',
                                                          'og:type' => 'article',
                                                          'oath:guce:consent-host' => 'guce.techcrunch.com',
                                                          'cxenseparse:title' => 'ChatGPT: Everything you need to know about the AI-powered chatbot',
                                                          'fb:app_id' => '187288694643718',
                                                          'cxenseparse:recs:publishtime' => '2023-05-12T12:00:52Z',
                                                          'twitter:card' => 'summary_large_image',
                                                          'cxenseparse:keywords' => 'ai,chatgpt,gpt-4,openai',
                                                          'twitter:label1' => 'Written by',
                                                          'og:title' => 'ChatGPT: Everything you need to know about the AI-powered chatbot',
                                                          'fb:pages' => '8062627951',
                                                          'viewport' => 'width=device-width',
                                                          'sailthru.date' => '2023-05-12 05:00:52',
                                                          'mrf:tags' => 'Page Type:Post-Free;Post ID:2517030;Primary Category:AI',
                                                          'sailthru.title' => 'ChatGPT: Everything you need to know about the AI-powered chatbot',
                                                          'twitter:data1' => 'Alyssa Stringer and Kyle Wiggers',
                                                          'cxenseparse:pageclass' => 'article',
                                                          'twitter:creator' => '@TechCrunch',
                                                          'cxenseparse:author' => 'Alyssa Stringer, Kyle Wiggers',
                                                          'og:image:type' => 'image/jpeg',
                                                          'article:publisher' => 'https://www.facebook.com/techcrunch',
                                                          'twitter:label2' => 'Est. reading time',
                                                          'author' => 'Alyssa Stringer and Kyle Wiggers',
                                                          'sailthru.image.full' => 'https://techcrunch.com/wp-content/uploads/2023/03/GettyImages-1462188043.jpg',
                                                          'og:image:height' => '798',
                                                          'og:description' => 'Here\'s a guide to help understand Open AI\'s viral text-generating system. We outline the most recent updates and answer the most common FAQs.',
                                                          'cxenseparse:image' => 'https://techcrunch.com/wp-content/uploads/2023/03/GettyImages-1462188043.jpg?w=601',
                                                          'oath:guce:product-eu' => 'false',
                                                          'og:locale' => 'en_US',
                                                          'twitter:site' => '@TechCrunch',
                                                          'og:site_name' => 'TechCrunch',
                                                          'article:modified_time' => '2023-05-12T18:22:01+00:00',
                                                          'fb:admins' => '8803025,726995222,1550970059,1661021707,1178144075,643979435,4700188',
                                                          'og:image' => 'https://techcrunch.com/wp-content/uploads/2023/03/GettyImages-1462188043.jpg?resize=1200,798',
                                                          'sailthru.author' => 'Alyssa Stringer',
                                                          'cxenseparse:modified_time' => '2023-05-12T18:22:01Z',
                                                          'og:url' => 'https://techcrunch.com/2023/05/12/chatgpt-everything-you-need-to-know-about-the-ai-powered-chatbot/',
                                                          'article:published_time' => '2023-05-12T12:00:52+00:00',
                                                          'sailthru.tags' => 'ChatGPT, gpt-4, OpenAI',
                                                          'cxenseparse:news_keywords' => 'ai,chatgpt,gpt-4,openai'
                                                        }
                                                      ],
                                        'cse_thumbnail' => [
                                                             {
                                                               'height' => '183',
                                                               'src' => 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTT1aayK14JzQgPFzWyAu963l1LnUMYLD4woFwl2IFC7L76fHS1VvjQt1vh',
                                                               'width' => '275'
                                                             }
                                                           ],
                                        'xfn' => [
                                                   {}
                                                 ]
                                      },
                         'title' => 'ChatGPT: Everything you need to know about the AI-powered ...',
                         'kind' => 'customsearch#result',
                         'link' => 'https://techcrunch.com/2023/05/12/chatgpt-everything-you-need-to-know-about-the-ai-powered-chatbot/',
                         'formattedUrl' => 'https://techcrunch.com/.../chatgpt-everything-you-need-to-know-about-the-ai -powered-chatbot/',
                         'displayLink' => 'techcrunch.com',
                         'cacheId' => 'WGemsyAklBoJ',
                         'htmlTitle' => '<b>ChatGPT</b>: Everything you need to know about the AI-powered ...',
                         'snippet' => "4 days ago ... ChatGPT, OpenAI's text-generating AI chatbot, has taken the world by storm. ... ChatGPT was recently super-charged by GPT-4, the latest\x{a0}...",
                         'htmlFormattedUrl' => 'https://techcrunch.com/.../<b>chatgpt</b>-everything-you-need-to-know-about-the-ai -powered-chatbot/',
                         'htmlSnippet' => '4 days ago <b>...</b> <b>ChatGPT</b>, OpenAI&#39;s text-generating AI chatbot, has taken the world by storm. ... <b>ChatGPT</b> was recently super-charged by GPT-4, the <b>latest</b>&nbsp;...'
                       },
                       {
                         'snippet' => "Mar 15, 2023 ... AI chatbots, including tools from Microsoft and Google, have been called out in recent weeks for being emotionally reactive, making factual\x{a0}...",
                         'htmlSnippet' => 'Mar 15, 2023 <b>...</b> AI chatbots, including tools from Microsoft and Google, have been called out in <b>recent</b> weeks for being emotionally reactive, making factual&nbsp;...',
                         'htmlFormattedUrl' => 'https://www.cnn.com/2023/03/14/tech/openai-gpt-4/index.html',
                         'displayLink' => 'www.cnn.com',
                         'htmlTitle' => '<b>Chat GPT</b>-4: OpenAI wants to make its chatbot even more powerful ...',
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.cnn.com/2023/03/14/tech/openai-gpt-4/index.html',
                         'formattedUrl' => 'https://www.cnn.com/2023/03/14/tech/openai-gpt-4/index.html',
                         'pagemap' => {
                                        'cse_thumbnail' => [
                                                             {
                                                               'height' => '168',
                                                               'src' => 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQT6F4CCPJcQMSRc7POXSm-1DYcHSRZ724VOIbua0oZQBG0nq4rCRZAmwQ',
                                                               'width' => '300'
                                                             }
                                                           ],
                                        'metatags' => [
                                                        {
                                                          'og:url' => 'https://www.cnn.com/2023/03/14/tech/openai-gpt-4/index.html',
                                                          'og:image' => 'https://media.cnn.com/api/v1/images/stellar/prod/230301111817-03-chatgpt-openai-stock.jpg?c=16x9&q=w_800,c_fill',
                                                          'author' => 'Samantha Murphy Kelly',
                                                          'meta-section' => 'business',
                                                          'og:type' => 'article',
                                                          'og:title' => 'The technology behind ChatGPT is about to get even more powerful | CNN Business',
                                                          'article:published_time' => '2023-03-14T19:14:03Z',
                                                          'viewport' => 'width=device-width,initial-scale=1,shrink-to-fit=no',
                                                          'twitter:title' => 'The technology behind ChatGPT is about to get even more powerful | CNN Business',
                                                          'twitter:site' => '@CNNbusiness',
                                                          'og:description' => 'Nearly four months after OpenAI stunned the tech industry with ChatGPT, the company is releasing its next-generation version of the technology that powers the viral chatbot tool.',
                                                          'type' => 'article',
                                                          'template_type' => 'article_leaf',
                                                          'twitter:description' => 'Nearly four months after OpenAI stunned the tech industry with ChatGPT, the company is releasing its next-generation version of the technology that powers the viral chatbot tool.',
                                                          'article:publisher' => 'https://www.facebook.com/CNN',
                                                          'article:modified_time' => '2023-03-15T08:42:56Z',
                                                          'twitter:card' => 'summary_large_image',
                                                          'twitter:image' => 'https://media.cnn.com/api/v1/images/stellar/prod/230301111817-03-chatgpt-openai-stock.jpg?c=16x9&q=w_800,c_fill',
                                                          'og:site_name' => 'CNN',
                                                          'theme' => 'business',
                                                          'fb:app_id' => '80401312489'
                                                        }
                                                      ],
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://media.cnn.com/api/v1/images/stellar/prod/230301111817-03-chatgpt-openai-stock.jpg?c=16x9&q=w_800,c_fill'
                                                         }
                                                       ]
                                      },
                         'title' => 'Chat GPT-4: OpenAI wants to make its chatbot even more powerful ...'
                       },
                       {
                         'displayLink' => 'www.dailymail.co.uk',
                         'cacheId' => 'HENCahEU9lAJ',
                         'htmlTitle' => '<b>ChatGPT news</b> - <b>Latest</b> on OpenAI&#39;s chat bot | Daily Mail Online',
                         'snippet' => 'Get the latest on OpenAI\'s chatbot. Trending ChatGPT News. Study reveals the jobs with the highest risk of being replaced by AI.',
                         'htmlSnippet' => 'Get the <b>latest</b> on OpenAI&#39;s chatbot. Trending <b>ChatGPT News</b>. Study reveals the jobs with the highest risk of being replaced by AI.',
                         'htmlFormattedUrl' => 'https://www.dailymail.co.uk/sciencetech/<b>chatgpt</b>/index.html',
                         'pagemap' => {
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://i.dailymail.co.uk/i/social/img_mol-logo_50x50.png'
                                                         }
                                                       ],
                                        'itemlist' => [
                                                        {
                                                          'itemlistelement' => 'Study reveals the jobs with the highest risk of being replaced by AI'
                                                        }
                                                      ],
                                        'metatags' => [
                                                        {
                                                          'y_key' => '1a7e912afbfcab2f',
                                                          'msapplication-task' => 'name=Register to Comment;action-uri=https://register.dailymail.co.uk/startRegister;icon-uri=https://i.dailymail.co.uk/i/furniture/ie9/jmplstic_register.ico',
                                                          'og:description' => 'ChatGPT news. Get the latest on OpenAI\'s chatbot.',
                                                          'doc-class' => 'Living Document',
                                                          'mobile-web-app-capable' => 'yes',
                                                          'twitter:account_id' => '15438913',
                                                          'app_store_id' => 'app-id=384101264',
                                                          'msapplication-starturl' => '/',
                                                          'og:site_name' => 'Mail Online',
                                                          'msapplication-tooltip' => 'MailOnline',
                                                          'fb:app_id' => '146202712090395',
                                                          'application-name' => 'MailOnline',
                                                          'msvalidate.01' => '12E6B4B813EB44C9BFC8F6A21F1D01F5',
                                                          'og:url' => 'http://www.dailymail.co.uk/sciencetech/chatgpt/index.html',
                                                          'og:image' => 'https://i.dailymail.co.uk/i/social/img_mol-logo_50x50.png',
                                                          'og:type' => 'website',
                                                          'viewport' => 'width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no',
                                                          'og:title' => 'ChatGPT news - Latest on OpenAI\'s chat bot | Daily Mail Online',
                                                          'fb:pages' => '164305410295882'
                                                        }
                                                      ],
                                        'cse_thumbnail' => [
                                                             {
                                                               'height' => '50',
                                                               'src' => 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT-vcBUn0Vd7lyLXSqPkCHSF7eDWUdJeg778h9rrMrzAQk3CuUjbPl-0A',
                                                               'width' => '50'
                                                             }
                                                           ]
                                      },
                         'title' => 'ChatGPT news - Latest on OpenAI\'s chat bot | Daily Mail Online',
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.dailymail.co.uk/sciencetech/chatgpt/index.html',
                         'formattedUrl' => 'https://www.dailymail.co.uk/sciencetech/chatgpt/index.html'
                       },
                       {
                         'snippet' => "Google has announced PaLM 2: its latest AI language model and competitor to rival systems like OpenAI's GPT-4. \x{201c}PaLM 2 models are stronger in logic and\x{a0}...",
                         'htmlSnippet' => "Google has announced PaLM 2: its <b>latest</b> AI language model and competitor to rival systems like OpenAI&#39;s GPT-4. \x{201c}PaLM 2 models are stronger in logic and&nbsp;...",
                         'htmlFormattedUrl' => 'https://www.theverge.com/.../chatbots-<b>chatgpt</b>-new-bing-google-bard- conversational-ai',
                         'displayLink' => 'www.theverge.com',
                         'htmlTitle' => 'Bing, Bard, <b>ChatGPT</b>, and all the <b>news</b> on AI chatbots - The Verge',
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.theverge.com/23610427/chatbots-chatgpt-new-bing-google-bard-conversational-ai',
                         'formattedUrl' => 'https://www.theverge.com/.../chatbots-chatgpt-new-bing-google-bard- conversational-ai',
                         'pagemap' => {
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://cdn.vox-cdn.com/thumbor/9YVnKybcBWblARoSVk0BTZt84JA=/0x0:2040x1360/1400x1400/filters:focal(1020x680:1021x681)/cdn.vox-cdn.com/uploads/chorus_asset/file/24440533/AI_Hands_A_Bernis_02.jpg'
                                                         }
                                                       ],
                                        'cse_thumbnail' => [
                                                             {
                                                               'height' => '225',
                                                               'src' => 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTiSTzt1VV6E1Ub4fs6LgVh-sBONdg8y_iSadIIzkE-59lGFDkqMfnFyyA',
                                                               'width' => '225'
                                                             }
                                                           ],
                                        'metatags' => [
                                                        {
                                                          'parsely-tags' => 'verge,front-page,ai-artificial-intelligence,tech,news,google,microsoft,web,featured-story,business',
                                                          'apple-mobile-web-app-title' => 'Verge',
                                                          'next-head-count' => '36',
                                                          'parsely-title' => 'Bing, Bard, and ChatGPT: AI chatbots are rewriting the internet',
                                                          'og:image:alt' => 'Hands with additional fingers typing on a keyboard.',
                                                          'parsely-author' => 'Umar Shakir',
                                                          'parsely-link' => 'https://www.theverge.com/23610427/chatbots-chatgpt-new-bing-google-bard-conversational-ai',
                                                          'og:image:type' => 'image/jpeg',
                                                          'author' => 'Umar Shakir',
                                                          'og:image:width' => '1200',
                                                          'parsely-pub-date' => '2023-02-23T19:02:53.450Z',
                                                          'og:type' => 'article',
                                                          'og:image:height' => '628',
                                                          'og:description' => 'All the stories about chatbots, conversational AI, and the new wave of search.',
                                                          'twitter:site' => '@verge',
                                                          'parsely-type' => 'post',
                                                          'og:site_name' => 'The Verge',
                                                          'fb:app_id' => '549923288395304',
                                                          'article:modified_time' => '2023-05-08T14:51:52.841Z',
                                                          'twitter:card' => 'summary_large_image',
                                                          'parsely-image-url' => 'https://cdn.vox-cdn.com/thumbor/DBN09iLiUZQKqjen8HjFjGTjzn8=/0x0:2040x1360/1200x628/filters:focal(1020x680:1021x681)/cdn.vox-cdn.com/uploads/chorus_asset/file/24440533/AI_Hands_A_Bernis_02.jpg',
                                                          'og:image' => 'https://cdn.vox-cdn.com/thumbor/DBN09iLiUZQKqjen8HjFjGTjzn8=/0x0:2040x1360/1200x628/filters:focal(1020x680:1021x681)/cdn.vox-cdn.com/uploads/chorus_asset/file/24440533/AI_Hands_A_Bernis_02.jpg',
                                                          'parsely-section' => 'front-page',
                                                          'og:url' => 'https://www.theverge.com/23610427/chatbots-chatgpt-new-bing-google-bard-conversational-ai',
                                                          'viewport' => 'width=device-width, initial-scale=1, shrink-to-fit=no',
                                                          'article:published_time' => '2023-02-23T19:02:53.450Z',
                                                          'og:title' => 'Bing, Bard, and ChatGPT: AI chatbots are rewriting the internet'
                                                        }
                                                      ]
                                      },
                         'title' => 'Bing, Bard, ChatGPT, and all the news on AI chatbots - The Verge'
                       },
                       {
                         'htmlTitle' => '<b>Latest ChatGPT news</b>',
                         'displayLink' => 'www.bleepingcomputer.com',
                         'cacheId' => 'igQeHsYv6r8J',
                         'htmlFormattedUrl' => 'https://www.bleepingcomputer.com/tag/<b>chatgpt</b>/',
                         'htmlSnippet' => 'The NYC Department of Education has banned the use of <b>ChatGPT</b> by students and teachers in New York City schools as there are serious concerns about its use&nbsp;...',
                         'snippet' => "The NYC Department of Education has banned the use of ChatGPT by students and teachers in New York City schools as there are serious concerns about its use\x{a0}...",
                         'title' => 'Latest ChatGPT news',
                         'pagemap' => {
                                        'cse_thumbnail' => [
                                                             {
                                                               'height' => '251',
                                                               'src' => 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTlUPYlPwvIT0nhPuEykIa3_khiiab_5LYIIvFBRh61-496uU27F5LDGY',
                                                               'width' => '201'
                                                             }
                                                           ],
                                        'listitem' => [
                                                        {
                                                          'name' => 'Home',
                                                          'position' => '1',
                                                          'item' => 'Home'
                                                        },
                                                        {
                                                          'position' => '2',
                                                          'name' => 'Latest ChatGPT news'
                                                        }
                                                      ],
                                        'metatags' => [
                                                        {
                                                          'owner' => 'Lawrence Abrams/BleepingComputer.com',
                                                          'og:locale' => 'en_us',
                                                          'application-name' => 'BleepingComputer',
                                                          'viewport' => 'width=device-width, initial-scale=1',
                                                          'og:site_name' => 'BleepingComputer',
                                                          'abstract' => 'The latest news about  ChatGPT'
                                                        }
                                                      ],
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://www.bleepstatic.com/comp/mandiant/mwise-conference-2023_cfs-extension_400x500_last-chance2.jpg'
                                                         }
                                                       ]
                                      },
                         'formattedUrl' => 'https://www.bleepingcomputer.com/tag/chatgpt/',
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.bleepingcomputer.com/tag/chatgpt/'
                       },
                       {
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.cnbc.com/2023/02/08/what-is-chatgpt-viral-ai-chatbot-at-heart-of-microsoft-google-fight.html',
                         'formattedUrl' => 'https://www.cnbc.com/.../what-is-chatgpt-viral-ai-chatbot-at-heart-of- microsoft-google-fight.html',
                         'pagemap' => {
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://media.nbcwashington.com/2023/02/107191176-1675871046625-gettyimages-1246879777-raa-openaich230207_npTfk-1.jpeg?quality=85&strip=all'
                                                         }
                                                       ],
                                        'webpage' => [
                                                       {
                                                         'datecreated' => '2023-02-08T12:37:31+0000',
                                                         'description' => 'Schools, corporate boardrooms and social media are abuzz with talk about ChatGPT, the artificial intelligence chatbot developed by AI startup OpenAI.',
                                                         'datemodified' => '2023-04-17T06:29:02+0000',
                                                         'contentrating' => 'NR',
                                                         'name' => 'What is ChatGPT? Viral AI chatbot at heart of Microsoft-Google fight',
                                                         'lastreviewed' => '2023-04-17T06:29:02+0000',
                                                         'inlanguage' => 'en-US',
                                                         'primaryimageofpage' => 'https://image.cnbcfm.com/api/v1/image/107191176-1675871046625-gettyimages-1246879777-raa-openaich230207_npTfk.jpeg?v=1676484288',
                                                         'specialty' => 'World economy,Jobs,Economy,Social media,Internet,Technology,Alphabet Inc,Microsoft Corp',
                                                         'image' => 'https://image.cnbcfm.com/api/v1/image/107191176-1675871046625-gettyimages-1246879777-raa-openaich230207_npTfk.jpeg?v=1676484288&w=1920&h=1080',
                                                         'datepublished' => '2023-02-08T12:37:31+0000',
                                                         'keywords' => 'World economy,Jobs,Economy,Social media,Internet,Technology,Alphabet Inc,Microsoft Corp,business news'
                                                       }
                                                     ],
                                        'metatags' => [
                                                        {
                                                          'twitter:site' => '@CNBC',
                                                          'article:opinion' => 'false',
                                                          'twitter:title' => 'All you need to know about ChatGPT, the A.I. chatbot that\'s got the world talking and tech giants clashing',
                                                          'apple-itunes-app' => 'app-id=398018310',
                                                          'og:description' => 'Schools, corporate boardrooms and social media are abuzz with talk about ChatGPT, the artificial intelligence chatbot developed by AI startup OpenAI.',
                                                          'twitter:description' => 'Schools, corporate boardrooms and social media are abuzz with talk about ChatGPT, the artificial intelligence chatbot developed by AI startup OpenAI.',
                                                          'article:modified_time' => '2023-04-17T06:29:02+0000',
                                                          'twitter:card' => 'summary_large_image',
                                                          'article:section' => 'Technology',
                                                          'og:site_name' => 'CNBC',
                                                          'twitter:image:src' => 'https://image.cnbcfm.com/api/v1/image/107191176-1675871046625-gettyimages-1246879777-raa-openaich230207_npTfk.jpeg?v=1676484288&w=1920&h=1080',
                                                          'og:url' => 'https://www.cnbc.com/2023/02/08/what-is-chatgpt-viral-ai-chatbot-at-heart-of-microsoft-google-fight.html',
                                                          'al:ios:app_store_id' => '398018310',
                                                          'parsely-metadata' => '{"nodeid":107190913,"originalImage":"https://image.cnbcfm.com/api/v1/image/107191176-1675871046625-gettyimages-1246879777-raa-openaich230207_npTfk.jpeg?v=1676484288"}',
                                                          'og:image' => 'https://image.cnbcfm.com/api/v1/image/107191176-1675871046625-gettyimages-1246879777-raa-openaich230207_npTfk.jpeg?v=1676484288&w=1920&h=1080',
                                                          'al:ios:app_name' => 'CNBC Business News and Finance',
                                                          'article:published_time' => '2023-02-08T12:37:31+0000',
                                                          'og:title' => 'All you need to know about ChatGPT, the A.I. chatbot that\'s got the world talking and tech giants clashing',
                                                          'tp:preferredformats' => 'M3U,MPEG4',
                                                          'viewport' => 'initial-scale=1.0, width=device-width',
                                                          'tp:preferredruntimes' => 'universal',
                                                          'twitter:creator' => '@Ryan_Browne_',
                                                          'format-detection' => 'telephone=no',
                                                          'article:publisher' => 'https://www.facebook.com/cnbc',
                                                          'article:author' => 'https://www.facebook.com/CNBC',
                                                          'article:tag' => 'World economy',
                                                          'author' => 'Ryan Browne',
                                                          'assettype' => 'cnbcnewsstory',
                                                          'twitter:url' => 'https://www.cnbc.com/2023/02/08/what-is-chatgpt-viral-ai-chatbot-at-heart-of-microsoft-google-fight.html',
                                                          'news_keywords' => 'World economy,Jobs,Economy,Social media,Internet,Technology,Alphabet Inc,Microsoft Corp,business news',
                                                          'og:type' => 'article',
                                                          'tp:initialize' => 'false',
                                                          'pagenodeid' => '107190913'
                                                        }
                                                      ],
                                        'cse_thumbnail' => [
                                                             {
                                                               'width' => '263',
                                                               'src' => 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRoUuwzi6OsrtMREC9fmOiMVgtJLdigrRw7cMpADF35uqNCvXMFMCco3P_A',
                                                               'height' => '191'
                                                             }
                                                           ],
                                        'newsmediaorganization' => [
                                                                     {
                                                                       'url' => 'https://www.cnbc.com',
                                                                       'foundingdate' => '\'1989-04-17\'',
                                                                       'name' => 'CNBC'
                                                                     }
                                                                   ]
                                      },
                         'title' => 'What is ChatGPT? Viral AI chatbot at heart of Microsoft-Google fight',
                         'snippet' => 'Feb 8, 2023 ... All you need to know about ChatGPT, the A.I. chatbot that\'s got the world ... at the World Economic Forum in Davos, Switzerland, last month.',
                         'htmlFormattedUrl' => 'https://www.cnbc.com/.../what-is-<b>chatgpt</b>-viral-ai-chatbot-at-heart-of- microsoft-google-fight.html',
                         'htmlSnippet' => 'Feb 8, 2023 <b>...</b> All you need to know about <b>ChatGPT</b>, the A.I. chatbot that&#39;s got the world ... at the World Economic Forum in Davos, Switzerland, <b>last</b> month.',
                         'displayLink' => 'www.cnbc.com',
                         'htmlTitle' => 'What is <b>ChatGPT</b>? Viral AI chatbot at heart of Microsoft-Google fight'
                       },
                       {
                         'snippet' => 'The latest breaking news, comment and features from The Independent.',
                         'htmlSnippet' => 'The <b>latest</b> breaking <b>news</b>, comment and features from The Independent.',
                         'htmlFormattedUrl' => 'https://www.independent.co.uk/topic/<b>chatgpt</b>',
                         'displayLink' => 'www.independent.co.uk',
                         'cacheId' => 'DX4ixza3P_wJ',
                         'htmlTitle' => '<b>ChatGPT</b> - <b>latest news</b>, breaking stories and comment - The ...',
                         'kind' => 'customsearch#result',
                         'link' => 'https://www.independent.co.uk/topic/chatgpt',
                         'formattedUrl' => 'https://www.independent.co.uk/topic/chatgpt',
                         'pagemap' => {
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://www.independent.co.uk/img/shortcut-icons/icon-96x96.png'
                                                         }
                                                       ],
                                        'metatags' => [
                                                        {
                                                          'fb:pages' => 'https://www.facebook.com/TheIndependentOnline',
                                                          'og:title' => 'ChatGPT | The Independent',
                                                          'viewport' => 'width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0',
                                                          'amp-google-client-id-api' => 'googleanalytics',
                                                          'og:type' => 'website',
                                                          'og:image' => 'https://www.independent.co.uk/img/shortcut-icons/icon-96x96.png',
                                                          'adpagetype' => 'Hub Page',
                                                          'og:url' => 'https://www.independent.co.uk/topic/chatgpt',
                                                          'theme-color' => '#F7F7F7',
                                                          'fb:app_id' => '235586169789578',
                                                          'og:site_name' => 'The Independent',
                                                          'twitter:image' => 'https://www.independent.co.uk/img/shortcut-icons/icon-96x96.png',
                                                          'twitter:card' => 'summary',
                                                          'twitter:description' => 'The latest breaking news, comment and features from The Independent.',
                                                          'page path' => '/topic/chatgpt',
                                                          'sitename' => 'The Independent',
                                                          'og:description' => 'The latest breaking news, comment and features from The Independent.',
                                                          'og:locale' => 'en_GB',
                                                          'category' => 'ChatGPT',
                                                          'page type' => 'Category',
                                                          'twitter:title' => 'ChatGPT | The Independent',
                                                          'twitter:site' => '@Independent'
                                                        }
                                                      ],
                                        'cse_thumbnail' => [
                                                             {
                                                               'height' => '96',
                                                               'src' => 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSweT3lqGtxFTtblanAafnWr4ts6y0kKlXlSNRQ0B1UWfDNPvpyujDnJQ',
                                                               'width' => '96'
                                                             }
                                                           ]
                                      },
                         'title' => 'ChatGPT - latest news, breaking stories and comment - The ...'
                       },
                       {
                         'link' => 'https://www.theguardian.com/technology/chatgpt',
                         'kind' => 'customsearch#result',
                         'formattedUrl' => 'https://www.theguardian.com/technology/chatgpt',
                         'pagemap' => {
                                        'metatags' => [
                                                        {
                                                          'twitter:app:name:ipad' => 'The Guardian',
                                                          'al:ios:app_name' => 'The Guardian',
                                                          'msapplication-tilecolor' => '#052962',
                                                          'og:title' => 'ChatGPT | Technology | The Guardian',
                                                          'fb:pages' => '10513336322',
                                                          'viewport' => 'width=device-width,minimum-scale=1,initial-scale=1',
                                                          'application-name' => 'The Guardian',
                                                          'og:url' => 'http://www.theguardian.com/technology/chatgpt',
                                                          'al:ios:app_store_id' => '409128287',
                                                          'twitter:card' => 'summary',
                                                          'handheldfriendly' => 'True',
                                                          'og:site_name' => 'the Guardian',
                                                          'fb:app_id' => '180444840287',
                                                          'twitter:app:name:iphone' => 'The Guardian',
                                                          'twitter:site' => '@guardian',
                                                          'twitter:app:url:iphone' => 'gnmguardian://technology/chatgpt?contenttype=list&source=twitter',
                                                          'og:type' => 'website',
                                                          'msapplication-tileimage' => 'https://assets.guim.co.uk/images/favicons/023dafadbf5ef53e0865e4baaaa32b3b/windows_tile_144_b.png',
                                                          'al:ios:url' => 'gnmguardian://technology/chatgpt?contenttype=list&source=applinks',
                                                          'twitter:app:name:googleplay' => 'The Guardian',
                                                          'theme-color' => '#052962',
                                                          'twitter:app:url:ipad' => 'gnmguardian://technology/chatgpt?contenttype=list&source=twitter',
                                                          'twitter:url' => 'https://www.theguardian.com/technology/chatgpt',
                                                          'twitter:app:id:ipad' => '409128287',
                                                          'twitter:app:id:googleplay' => 'com.guardian',
                                                          'format-detection' => 'telephone=no',
                                                          'twitter:dnt' => 'on',
                                                          'twitter:app:id:iphone' => '409128287',
                                                          'apple-mobile-web-app-title' => 'Guardian'
                                                        }
                                                      ],
                                        'cse_thumbnail' => [
                                                             {
                                                               'width' => '290',
                                                               'height' => '174',
                                                               'src' => 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSckk4WdzTXEHNblxL5ZGOcxm0mDhbZlqUoBPEYDSlsNgTs9xk3PltgUsM'
                                                             }
                                                           ],
                                        'cse_image' => [
                                                         {
                                                           'src' => 'https://i.guim.co.uk/img/media/d1c853790f13f2c449fd86914a709aa0d50098b7/0_319_5454_3273/master/5454.jpg?width=300&quality=85&auto=format&fit=max&s=baedd4fb3a41af520ca009777a2a4fa1'
                                                         }
                                                       ],
                                        'webpage' => [
                                                       {
                                                         'keywords' => 'Artificial intelligence (AI)'
                                                       }
                                                     ]
                                      },
                         'title' => 'ChatGPT | Technology | The Guardian',
                         'snippet' => "2 days ago ... ChatGPT \x{b7} TechScape \x{b7} Nearly 50 news websites are 'AI-generated', a study says. \x{b7} Rise of artificial intelligence is inevitable but should not be\x{a0}...",
                         'htmlFormattedUrl' => 'https://www.theguardian.com/technology/<b>chatgpt</b>',
                         'htmlSnippet' => '2 days ago <b>...</b> <b>ChatGPT</b> &middot; TechScape &middot; Nearly 50 <b>news</b> websites are &#39;AI-generated&#39;, a study says. &middot; Rise of artificial intelligence is inevitable but should not be&nbsp;...',
                         'cacheId' => 'dsYro2J9iJYJ',
                         'displayLink' => 'www.theguardian.com',
                         'htmlTitle' => '<b>ChatGPT</b> | Technology | The Guardian'
                       }
                     ],
          'context' => {
                         'title' => 'Playing with LLM-powered automation'
                       }
        };
