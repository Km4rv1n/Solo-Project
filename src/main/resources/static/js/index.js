// ---- Footer ----
document.getElementById("currentYear").innerText = new Date().getFullYear();
// ---- Footer End----


// ---- Translator ----
document.addEventListener('mouseup', function() {
    getSelectedText();
});

function getSelectedText() {
    var selectedText = window.getSelection().toString();
    if (selectedText) {
        console.log('Selected Text: ' + selectedText);
        translateSelectedText(selectedText);
    }
}

async function translateSelectedText(text) {
    const language = document.getElementById("languageSelect").value;
    try {
        const response = await fetch(`/api/translate?text=${encodeURIComponent(text)}&language=${language}`);
        const data = await response.json();
        console.log('Translated Text: ' + data.translatedText);
        displayTranslatedText(data.translatedText);
    } catch (error) {
        console.error('Error translating text:', error);
    }
}

function displayTranslatedText(translatedText) {
    alert('Translated Text: ' + translatedText);
}

// ---- Translator End ----

// ---- Pagination Links ----
const currentPath = window.location.pathname;
const links = document.querySelectorAll('.nav-link');

links.forEach(link => {
    if (link.getAttribute('href').split('?')[0] === currentPath) {
        link.classList.add('active');
    }
});
// ---- Pagination Links End ----



// ---- START - VIEW POST PAGE ----
const showLikesModalLink = document.getElementById("show-likes-modal");
const likesModal = document.getElementById("likes-modal");
showLikesModalLink.addEventListener('click', function (){
    likesModal.showModal();
})
// ---- END - VIEW POST PAGE ----



