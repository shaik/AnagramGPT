# AnagramGPT - Hebrew Anagram Solver

A modern web application for finding Hebrew word anagrams, built with React, Chakra UI, and Perl.

## Features

- 🔤 Hebrew text input with RTL support
- ⚡️ Real-time anagram generation
- 🎨 Modern, responsive UI with Chakra UI
- 🌛 Dark/Light mode support (coming soon)
- 🚀 Fast Perl-based anagram solving engine
- 🌐 RESTful API architecture

## Tech Stack

### Frontend
- React 18+ with Vite
- Chakra UI for modern component design
- Framer Motion for smooth animations
- RTL support for Hebrew text

### Backend
- Perl with Mojolicious web framework
- Custom Anagram::Solver module
- Unicode support for Hebrew text processing

## Getting Started

### Prerequisites

- Node.js 16+
- Perl 5.30+
- cpanm (Perl module installer)

### Installation

1. Install Perl dependencies:
```bash
cpanm --local-lib=~/perl5 local::lib
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
cpanm Mojolicious
```

2. Install frontend dependencies:
```bash
cd frontend
npm install
```

### Running the Application

1. Start the backend server:
```bash
perl -I ~/perl5/lib/perl5/ api/server.pl
```

2. Start the frontend development server:
```bash
cd frontend
npm run dev
```

3. Open http://localhost:5173 in your browser

## Project Structure

```
├── api/
│   └── server.pl          # Mojolicious API server
├── frontend/
│   ├── src/
│   │   ├── components/    # React components
│   │   └── theme.js       # Chakra UI theme
│   ├── package.json
│   └── vite.config.js
├── lib/
│   ├── Anagram/
│   │   ├── Solver.pm      # Anagram solving logic
│   │   └── Dictionary.pm  # Hebrew dictionary handling
│   └── data/
│       └── hebrew_dict.txt # Hebrew word dictionary
└── README.md
```

## API Endpoints

### POST /api/anagram

Generates anagrams for the provided Hebrew text.

**Request:**
```json
{
  "text": "שלום"
}
```

**Response:**
```json
{
  "results": [
    ["של", "ום"],
    ["שלום"]
  ]
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

