import { useEffect, useMemo, useState } from 'react'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import guideEn from '../content/guide.en.md?raw'
import guidePt from '../content/guide.pt.md?raw'
import architectureEn from '../content/architecture.en.md?raw'
import architecturePt from '../content/architecture.pt.md?raw'
import './App.css'

type Lang = 'en' | 'pt'
type Page = 'guide' | 'architecture'

const VERSION = '0.1.0-preview.6'

function detectLang(): Lang {
  const params = new URLSearchParams(window.location.search)
  const q = params.get('lang')
  if (q === 'pt' || q === 'en') return q
  const nav = navigator.language?.toLowerCase() ?? 'en'
  return nav.startsWith('pt') ? 'pt' : 'en'
}

function detectPage(): Page {
  const params = new URLSearchParams(window.location.search)
  return params.get('page') === 'architecture' ? 'architecture' : 'guide'
}

export default function App() {
  const [lang, setLang] = useState<Lang>(() => detectLang())
  const [page, setPage] = useState<Page>(() => detectPage())

  useEffect(() => {
    const url = new URL(window.location.href)
    url.searchParams.set('lang', lang)
    url.searchParams.set('page', page)
    window.history.replaceState({}, '', url)
    document.documentElement.lang = lang === 'pt' ? 'pt-BR' : 'en'
  }, [lang, page])

  const markdown = useMemo(() => {
    if (page === 'architecture') {
      return lang === 'pt' ? architecturePt : architectureEn
    }
    return lang === 'pt' ? guidePt : guideEn
  }, [lang, page])

  const title =
    page === 'architecture'
      ? lang === 'pt'
        ? 'Arquitetura'
        : 'Architecture'
      : lang === 'pt'
        ? 'Guia de Desenvolvimento'
        : 'Development Guide'

  return (
    <div className="shell">
      <header className="topbar">
        <div>
          <p className="eyebrow">PolyStack DevKit</p>
          <h1>{title}</h1>
        </div>
        <div className="actions">
          <div className="lang" role="group" aria-label="Language">
            <button
              type="button"
              className={lang === 'en' ? 'active' : undefined}
              onClick={() => setLang('en')}
            >
              EN
            </button>
            <button
              type="button"
              className={lang === 'pt' ? 'active' : undefined}
              onClick={() => setLang('pt')}
            >
              PT
            </button>
          </div>
          <a
            className="external"
            href="https://github.com/getpolystack/devkit"
            target="_blank"
            rel="noreferrer"
          >
            GitHub
          </a>
        </div>
      </header>

      <nav className="tabs" aria-label={lang === 'pt' ? 'Seções' : 'Sections'}>
        <button
          type="button"
          className={page === 'guide' ? 'active' : undefined}
          onClick={() => setPage('guide')}
        >
          {lang === 'pt' ? 'Guia de Desenvolvimento' : 'Development Guide'}
        </button>
        <button
          type="button"
          className={page === 'architecture' ? 'active' : undefined}
          onClick={() => setPage('architecture')}
        >
          {lang === 'pt' ? 'Arquitetura' : 'Architecture'}
        </button>
      </nav>

      <main className="panel">
        <article className="prose">
          <ReactMarkdown remarkPlugins={[remarkGfm]}>{markdown}</ReactMarkdown>
        </article>
      </main>

      <footer className="footer">
        <span>{VERSION}</span>
        <span>
          {lang === 'pt'
            ? 'Documentação do DevKit (não é o site de apresentação).'
            : 'DevKit documentation (not the presentation site).'}
        </span>
      </footer>
    </div>
  )
}
