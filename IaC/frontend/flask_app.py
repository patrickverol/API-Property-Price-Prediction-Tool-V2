from flask import Flask, render_template, request
import httpx
import asyncio
from dotenv import load_dotenv
import os

load_dotenv()  # This will load the .env file

# Use getenv with a fallback value
public_dns = os.getenv('AWS_EC2_FASTAPI_DNS')

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        try:
            # Collect form data
            host_name = request.form['host_name']
            host_listings_count = int(request.form['host_listings_count'])
            latitude = float(request.form['latitude'])
            longitude = float(request.form['longitude'])
            accommodates = int(request.form['accommodates'])
            bathrooms = int(request.form['bathrooms'])
            bedrooms = int(request.form['bedrooms'])
            beds = int(request.form['beds'])
            extra_people = int(request.form['extra_people'])
            minimum_nights = int(request.form['minimum_nights'])
            n_amenities = int(request.form['n_amenities'])

            room_type_Entire_home_apt = int(request.form['room_type_Entire_home_apt'])
            host_is_superhost = int(request.form['host_is_superhost'])
            instant_bookable = int(request.form['instant_bookable'])
            ano = int(request.form['ano'])
            mes = int(request.form['mes'])

            property_type_Apartment = int(request.form['property_type_Apartment'])
            property_type_Bed_and_breakfast = int(request.form['property_type_Bed_and_breakfast'])
            property_type_Condominium = int(request.form['property_type_Condominium'])
            property_type_House = int(request.form['property_type_House'])

            room_type_Hotel_room = int(request.form['room_type_Hotel_room'])
            room_type_Private_room = int(request.form['room_type_Private_room'])
            room_type_Shared_room = int(request.form['room_type_Shared_room'])

            cancellation_policy_flexible = int(request.form['cancellation_policy_flexible'])
            cancellation_policy_moderate = int(request.form['cancellation_policy_moderate'])
            cancellation_policy_strict = int(request.form['cancellation_policy_strict'])
            cancellation_policy_strict_14_with_grace_period = int(request.form['cancellation_policy_strict_14_with_grace_period'])

            property_type_Guest_suite = int(request.form['property_type_Guest_suite'])
            property_type_Guesthouse = int(request.form['property_type_Guesthouse'])
            property_type_Hostel = int(request.form['property_type_Hostel'])
            property_type_Loft = int(request.form['property_type_Loft'])
            property_type_Outros = int(request.form['property_type_Outros'])
            property_type_Serviced_apartment = int(request.form['property_type_Serviced_apartment'])

            # Build payload wrapped in 'especificacoes_imovel' and include 'host_name'
            dados_entrada = {
                'especificacoes_imovel': {
                    'host_listings_count': host_listings_count,
                    'latitude': latitude,
                    'longitude': longitude,
                    'accommodates': accommodates,
                    'bathrooms': bathrooms,
                    'bedrooms': bedrooms,
                    'beds': beds,
                    'extra_people': extra_people,
                    'minimum_nights': minimum_nights,
                    'n_amenities': n_amenities,
                    'room_type_Entire_home_apt': room_type_Entire_home_apt,
                    'host_is_superhost': host_is_superhost,
                    'instant_bookable': instant_bookable,
                    'ano': ano,
                    'mes': mes,
                    'property_type_Apartment': property_type_Apartment,
                    'property_type_Bed_and_breakfast': property_type_Bed_and_breakfast,
                    'property_type_Condominium': property_type_Condominium,
                    'property_type_House': property_type_House,
                    'room_type_Hotel_room': room_type_Hotel_room,
                    'room_type_Private_room': room_type_Private_room,
                    'room_type_Shared_room': room_type_Shared_room,
                    'cancellation_policy_flexible': cancellation_policy_flexible,
                    'cancellation_policy_moderate': cancellation_policy_moderate,
                    'cancellation_policy_strict': cancellation_policy_strict,
                    'cancellation_policy_strict_14_with_grace_period': cancellation_policy_strict_14_with_grace_period,
                    'property_type_Guest_suite': property_type_Guest_suite,
                    'property_type_Guesthouse': property_type_Guesthouse,
                    'property_type_Hostel': property_type_Hostel,
                    'property_type_Loft': property_type_Loft,
                    'property_type_Outros': property_type_Outros,
                    'property_type_Serviced_apartment': property_type_Serviced_apartment
                },
                'host_name': host_name
            }

            # Make asynchronous prediction request to FastAPI
            async def get_prediction():
                async with httpx.AsyncClient() as client:
                    response = await client.post(f"http://{public_dns}:5001/prever/", json=dados_entrada)
                    response.raise_for_status()
                    return response.json()

            preco_estimado = asyncio.run(get_prediction())

            return render_template('index.html', preco_estimado=f"R$ {str(preco_estimado['preco_estimado']).replace('.', ',')}")

        except httpx.HTTPStatusError as e:
            return render_template('index.html', error=f"Erro na solicitação: {e}")
        except Exception as e:
            return render_template('index.html', error=f"Erro inesperado: {e}")

    # Render form if GET request
    return render_template('index.html')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
