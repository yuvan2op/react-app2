import { render, screen } from '@testing-library/react';
import App from './App';

test('renders app title', () => {
  render(<App />);
  expect(screen.getByText(/React App 2 · Playground/i)).toBeInTheDocument();
});


