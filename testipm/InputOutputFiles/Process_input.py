import nltk
from nltk.stem import PorterStemmer
from nltk.stem import SnowballStemmer
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer

# ps = SnowballStemmer("english")
# ps = PorterStemmer()
ps = WordNetLemmatizer()

def extractKeywords(text):
    stop_words = stopwords.words('english')
    stop_words = set(stop_words)
    msg = text
    words = word_tokenize(msg.lower())
    print(words)
    filtered_words = set()

    for word in words:
        if word not in stop_words and word.isalnum():
            stemmed_word = ps.stem(word)
            filtered_words.add(stemmed_word)
    return list(filtered_words)

def extractRootwords(text):
    words = word_tokenize(text.lower())
    root_words = [ps.lemmatize(word) for word in words]
    msg = " ".join(root_words)
    return msg

def getRightExtension(text):
    extension_list = ['txt', 'docx', 'py', 'c', 'cpp', 'java', 'rb', 'html', 'css', 'js']
    match_ratio_list = [fuzz.ratio(text, ext) for ext in extension_list]
    max_match_ratio_index = match_ratio_list.index(max(match_ratio_list))
    return extension_list[max_match_ratio_index]

def createFileName(text):
    fileText = text.split('dot')
    filename = '_'.join(fileText[0].split(' '))
    try:
        extension = '.'+getRightExtension(fileText[1])

    except:
        extension = '.txt'
    file = filename+extension
    return file

# createFileName("my file")
print(extractRootwords("give me the jira issue"))