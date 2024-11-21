// scripts.js

let historyStack = [];  // Stores visited URLs
let currentHistoryIndex = -1;  // Tracks current position in history

// Function to load the page
function loadPage() {
    const urlInput = document.getElementById('urlInput');
    let url = urlInput.value.trim();

    // Ensure the URL has the correct format
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://' + url;
    }

    // Display loading screen
    document.getElementById('loadingScreen').style.display = 'flex';

    // Load the page into the iframe
    const iframe = document.getElementById('browserFrame');
    iframe.src = url;

    // Manage the browser history
    if (currentHistoryIndex === historyStack.length - 1) {
        historyStack.push(url);
    } else {
        historyStack = historyStack.slice(0, currentHistoryIndex + 1);
        historyStack.push(url);
    }
    currentHistoryIndex = historyStack.length - 1;

    // Update the address bar
    document.getElementById('urlInput').value = url;
}

// Function to go back in history
function navigateBack() {
    if (currentHistoryIndex > 0) {
        currentHistoryIndex--;
        const previousUrl = historyStack[currentHistoryIndex];
        document.getElementById('browserFrame').src = previousUrl;
    }
}

// Function to go forward in history
function navigateForward() {
    if (currentHistoryIndex < historyStack.length - 1) {
        currentHistoryIndex++;
        const nextUrl = historyStack[currentHistoryIndex];
        document.getElementById('browserFrame').src = nextUrl;
    }
}

// Function to hide loading screen when the page is loaded
function pageLoaded() {
    document.getElementById('loadingScreen').style.display = 'none';
}

// Function to check if the Enter key is pressed in the address bar
function checkEnter(event) {
    if (event.key === 'Enter') {
        loadPage();
    }
}

// Initialize a default starting page
window.onload = function() {
    document.getElementById('urlInput').value = 'https://www.example.com';
    loadPage();
};
