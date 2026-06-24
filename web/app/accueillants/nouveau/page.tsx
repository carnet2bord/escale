import { Header } from '@/app/_components/Header';
import { FormAccueillant } from '../FormAccueillant';

export default function NouvelAccueillant() {
  return (
    <>
      <Header actif="/accueillants" />
      <div className="contenu">
        <h1>Nouvel accueillant</h1>
        <FormAccueillant />
      </div>
    </>
  );
}
