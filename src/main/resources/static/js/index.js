// ---- START - ALL PAGES ----
document.getElementById("currentYear").innerText = new Date().getFullYear();
// ---- END - ALL PAGES ----


// ---- START - VIEW POST PAGE ----
const showLikesModalLink = document.getElementById("show-likes-modal");
const likesModal = document.getElementById("likes-modal");
showLikesModalLink.addEventListener('click', function (){
    likesModal.showModal();
})
// ---- END - VIEW POST PAGE ----



